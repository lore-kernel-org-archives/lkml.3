Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab3ILUx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:53:57 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:60601 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab3ILUxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:53:53 -0400
Date: Thu, 12 Sep 2013 22:53:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mark Salter <msalter@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, rth@twiddle.net, vgupta@synopsys.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, geert@linux-m68k.org,
        monstr@monstr.eu, ralf@linux-mips.org, jejb@parisc-linux.org,
        benh@kernel.crashing.org, lethal@linux-sh.org, davem@davemloft.net,
        cmetcalf@tilera.com, gxt@mprc.pku.edu.cn, tglx@linutronix.de,
        mingo@redhat.com
Subject: Re: [PATCH] Kconfig cleanup (PARPORT_PC dependencies)
Message-ID: <20130912205349.GC3262@gmail.com>
References: <1379012038-31764-1-git-send-email-msalter@redhat.com>
 <52321F0B.4070609@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52321F0B.4070609@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 09/12/2013 11:53 AM, Mark Salter wrote:
> >  
> > diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
> > index 70694ce..fa005a9 100644
> > --- a/drivers/parport/Kconfig
> > +++ b/drivers/parport/Kconfig
> > @@ -35,9 +35,7 @@ if PARPORT
> >  
> >  config PARPORT_PC
> >  	tristate "PC-style hardware"
> > -	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV && !S390 && \
> > -		(!M68K || ISA) && !MN10300 && !AVR32 && !BLACKFIN && \
> > -		!XTENSA && !CRIS && !H8300
> > +	depends on ARCH_MAY_HAVE_PC_PARPORT
> >  
> >  	---help---
> >  	  You should say Y here if you have a PC-style parallel port. All
> > 
> 
> I'm somewhat astonished that this driver is that problematic.  It is 
> really just a very basic PIO interface, at least in the absence of 
> EPP/ECP.
> 
> It is, of course, also largely a dead interface at this point so it 
> probably doesn't matter.

So, my collection of 'randconfig kernel crashers' has this exclusion and 
comment:

 --- linux.orig/drivers/block/Kconfig
 +++ linux/drivers/block/Kconfig
 @@ -77,6 +77,11 @@ config GDROM
  config PARIDE
         tristate "Parallel port IDE device support"
         depends on PARPORT_PC
 +
 +       # the probe can hang during bootup on non-PARIDE boxes
 +       depends on BROKEN_BOOT_ALLOWED
 +       select BROKEN_BOOT if PARIDE = y
 +

So at least some uses of PARPORT_PC are unsafe. (might easily be a bug in 
PARIDE)

Thanks,

	Ingo
