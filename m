Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab3FZVeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:34:23 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38775 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3FZVeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:34:22 -0400
Date: Wed, 26 Jun 2013 23:34:10 +0200
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, nico@linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 0/2] arm: add early_ioremap() support
Message-ID: <20130626213409.GA18151@rocoto.smurfnet.nu>
References: <1372182401-11029-1-git-send-email-leif.lindholm@linaro.org>
 <201306262052.09640.arnd@arndb.de>
 <20130626192352.GE9078@rocoto.smurfnet.nu>
 <201306262323.50691.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306262323.50691.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 11:23:50PM +0200, Arnd Bergmann wrote:
> > Is this an issue here, since (unlike x86) this early_ioremap only works
> > before paging_init()?
> 
> The main problem is that the total fixmap size is only around 900kb,
> and we want to reserve at least 64kb per cpu for kmap_atomic.
> If you want to fit multiple 128kb mappings in there, you run out of
> space really fast.
 
Sorry, I still don't get it. Are you saying that kmap_atomic is
available before kmap_init() (in paging_init())?

If not, all of my mappings are discarded (well, abandoned to be more
correct), so I don't see how it affects kmap.

> > > Extending the iotable mechanism on ARM would be the convenient
> > > solution for us I think.
> > 
> > Could that easily be extended to give similar semantics sufficiently
> > that we can progress with merging more of the UEFI and ACPI support 
> > together as common code with x86/ia64?
> 
> I don't know what the requirements are, but the idea with iotable
> is that the mappings stay around at run time, while it seems you want
> to discard them at some point.
 
Indeed - almost immediately.

x86 early_ioremap can coexist with kmap; the intent of my
implementation is to use the kmap region only before kmap is available.

/
    Leif
