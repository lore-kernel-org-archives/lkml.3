Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab3FQObF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:31:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43097 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab3FQObD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:31:03 -0400
Date: Mon, 17 Jun 2013 15:30:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jonas Jensen <jonas.jensen@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ulli.kroll@googlemail.com, arm@kernel.org,
        Florian Fainelli <florian@openwrt.org>, Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [PATCH] ARM: mm: cpu_fa526_do_idle: remove WFI
Message-ID: <20130617143021.GI2718@n2100.arm.linux.org.uk>
References: <1371476360-8751-1-git-send-email-jonas.jensen@gmail.com> <5020304.hteFFmWh1u@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5020304.hteFFmWh1u@wuerfel>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 04:14:03PM +0200, Arnd Bergmann wrote:
> On Monday 17 June 2013 15:39:20 Jonas Jensen wrote:
> > As it was already suggested by Russell King and Arnd Bergmann ( https://lkml.org/lkml/2013/5/16/133 ), moxart and gemini seem to be the only platforms using CPU_FA526, and instead of pointing arm_pm_idle to an empty function from platform code, it makes sense to remove WFI code from the processor specific idle function.
> > 
> > Note: moxart boots and prints to UART without this patch, but input is broken.
> 
> Please make sure you have proper line wraps. Lines in checkin
> comments should be no longer than 70 characters normally.
> 
> > Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> Since this patch is independent from the actual platform support,
> it should go through Russell's patch tracker at
> http://www.arm.linux.org.uk/developer/patches/

Except... the patch is wrong.

> >  arch/arm/mm/proc-fa526.S |    4 +---
> >  1 files changed, 1 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm/mm/proc-fa526.S b/arch/arm/mm/proc-fa526.S
> > index d217e97..85280b1 100644
> > --- a/arch/arm/mm/proc-fa526.S
> > +++ b/arch/arm/mm/proc-fa526.S
> > @@ -81,9 +81,7 @@ ENDPROC(cpu_fa526_reset)
> >   */
> >  	.align	4
> >  ENTRY(cpu_fa526_do_idle)
> > -	mcr	p15, 0, r0, c7, c0, 4		@ Wait for interrupt
> > -	mov	pc, lr
> > -
> > +	nop

It replaces the WFI and return with a pure nop, so we will fall through
to cpu_fa526_dcache_clean_area().  Do we really want to clean a random
D cache entry depending on what r0 happened to hold at this point?  I
think not...
