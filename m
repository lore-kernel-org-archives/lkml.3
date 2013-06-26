Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab3FZTYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:24:03 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:44402 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3FZTYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:24:00 -0400
Date: Wed, 26 Jun 2013 21:23:53 +0200
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, nico@linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 0/2] arm: add early_ioremap() support
Message-ID: <20130626192352.GE9078@rocoto.smurfnet.nu>
References: <1372182401-11029-1-git-send-email-leif.lindholm@linaro.org>
 <201306262052.09640.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306262052.09640.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 08:52:09PM +0200, Arnd Bergmann wrote:
> I made a similar suggestion to extending the use of fixmap recently, see
> "Re: SCU registers mapping for CA9/CA5 cores". Russell pointed out that
> fixmap is intentionally limited to just kmap_atomic uses at the moment
> and changing that would potentially have a significant impact when we
> run out of pages in the fixmap area.
 
Is this an issue here, since (unlike x86) this early_ioremap only works
before paging_init()?

> The method we use on ARM normally is the iotable_init() function, which
> requires hardcoding a virtual address at the moment.
> 
> It might be nicer to change that code than to put early_ioremap into
> fixmap. Note that early_ioremap in fixmap is a bit of a kludge on x86
> as well because it is very much /not/ a fixed mapping like the rest
> of fixmap, they just use it because it's convenient.
 
Yes, but they also only use it (at least the bits where I looked) for
temporary mappings very early in the boot process. That is certainly
how I use it. So at least my intention was to use it before kmap is
even available.

> Extending the iotable mechanism on ARM would be the convenient
> solution for us I think.

Could that easily be extended to give similar semantics sufficiently
that we can progress with merging more of the UEFI and ACPI support 
together as common code with x86/ia64?

/
    Leif
