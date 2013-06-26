Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab3FZXZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:25:16 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37693 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab3FZXZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:25:13 -0400
Date: Thu, 27 Jun 2013 01:25:06 +0200
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, nico@linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 0/2] arm: add early_ioremap() support
Message-ID: <20130626232504.GB18151@rocoto.smurfnet.nu>
References: <1372182401-11029-1-git-send-email-leif.lindholm@linaro.org>
 <201306262323.50691.arnd@arndb.de>
 <20130626213409.GA18151@rocoto.smurfnet.nu>
 <201306270013.55333.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306270013.55333.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 12:13:55AM +0200, Arnd Bergmann wrote:
> > Sorry, I still don't get it. Are you saying that kmap_atomic is
> > available before kmap_init() (in paging_init())?
> > 
> > If not, all of my mappings are discarded (well, abandoned to be more
> > correct), so I don't see how it affects kmap.
> 
> Sorry, I was under the assumption that the mappings are meant to
> stay around.
 
Ok, just so I'm not completely lost :)

No, the purpose is just like for x86 - do early parsing of things like
the UEFI system and configuration tables, DMI and ACPI, in order to
populate global structs and stuff.

> > Indeed - almost immediately.
> > 
> > x86 early_ioremap can coexist with kmap; the intent of my
> > implementation is to use the kmap region only before kmap is available.
> 
> So if you never plan to use fixmap and early_ioremap at the same time,
> why even bother using the fixmap code? Wouldn't it be easier to just
> use the same memory area and ensure we never use fixmap before 
> we're done with early_ioremap?

Well, I did have a crazy idea that much/most of the early_ioremap code
could be made generic and shared between x86 and arm (and any other
32-bit architecture). Using the fixmap macros would make that possible
with a minimum of ifdefs.

If we ever wanted early_ioremap() to work like on x86, beyond kmap_init()
(but not beyond the "booting" system state), using the same macros would
help there too. I had no need for that for my EFI patches.

/
    Leif
