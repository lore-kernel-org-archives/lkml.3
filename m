Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaCVQYQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 12:24:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaCVQYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 12:24:13 -0400
Date: Sat, 22 Mar 2014 09:25:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thomas Backlund <tmb@mageia.org>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org, geert@linux-m68k.org, richard@nod.at,
        scottwood@freescale.com
Subject: Re: [PATCH 3.13 000/149] 3.13.7-stable review
Message-ID: <20140322162542.GB13385@kroah.com>
References: <20140321000436.377902063@linuxfoundation.org>
 <532BD009.7020204@roeck-us.net>
 <532BFB76.60709@mageia.org>
 <532BFFB9.1010307@mageia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532BFFB9.1010307@mageia.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 11:00:41AM +0200, Thomas Backlund wrote:
> Thomas Backlund skrev 21.3.2014 10:42:
> > Guenter Roeck skrev 21.3.2014 07:37:
> >> On 03/20/2014 05:02 PM, Greg Kroah-Hartman wrote:
> >>> This is the start of the stable review cycle for the 3.13.7 release.
> >>> There are 149 patches in this series, all will be posted as a response
> >>> to this one.  If anyone has any issues with these being applied, please
> >>> let me know.
> >>>
> >>> Responses should be made by Sun Mar 23 00:03:54 UTC 2014.
> >>> Anything received after that time might be too late.
> >>>
> >>
> >> Build results:
> >>      total: 126 pass: 120 skipped: 4 fail: 2
> >>
> >> qemu tests all passed.
> >>
> >> There are two new build failures.
> >>
> >> Building powerpc:mpc85xx_defconfig ... failed
> >> Building powerpc:mpc85xx_smp_defconfig ... failed
> >>
> >> The failure is the same in both cases.
> >>
> >> drivers/i2c/busses/i2c-cpm.c: In function 'cpm_i2c_setup':
> >> drivers/i2c/busses/i2c-cpm.c:450:2: error: implicit declaration of
> >> function 'irq_of_parse_and_map' [-Werror=implicit-function-declaration]
> >> drivers/i2c/busses/i2c-cpm.c:461:2: error: implicit declaration of
> >> function 'of_iomap' [-Werror=implicit-function-declaration]
> >>
> >> It appears you picked this up from the latest mainline, where the
> >> same builds fail with the same error. The problem was introduced
> >> in mainline between rc6 and rc7.
> >>
> >> I have no immediate idea which patch causes the problem.
> >> I can bisect tomorrow if needed.
> >
> > Probably this one exposing additional code to be built:
> >
> >
> >  From 62c19c9d29e65086e5ae76df371ed2e6b23f00cd Mon Sep 17 00:00:00 2001
> > From: Richard Weinberger <richard@nod.at>
> > Date: Sun, 9 Feb 2014 19:47:40 +0100
> > Subject: i2c: Remove usage of orphaned symbol OF_I2C
> >
> > From: Richard Weinberger <richard@nod.at>
> >
> > commit 62c19c9d29e65086e5ae76df371ed2e6b23f00cd upstream.
> >
> > The symbol is an orphan, don't depend on it anymore.
> >
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > [wsa: enhanced commit message]
> > Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> > Fixes: 687b81d083c0 (i2c: move OF helpers into the core)
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > ---
> >   drivers/i2c/busses/Kconfig |    2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > --- a/drivers/i2c/busses/Kconfig
> > +++ b/drivers/i2c/busses/Kconfig
> > @@ -387,7 +387,7 @@ config I2C_CBUS_GPIO
> >
> >   config I2C_CPM
> >          tristate "Freescale CPM1 or CPM2 (MPC8xx/826x)"
> > -       depends on (CPM1 || CPM2) && OF_I2C
> > +       depends on CPM1 || CPM2
> >          help
> >            This supports the use of the I2C interface on Freescale
> >            processors with CPM1 or CPM2.
> >
> >
> 
> 
> and the buildfix was posted to upstream and -stable a couple of days ago 
> (not in upstream linus tree yet), with subject:
> 
> [PATCH] i2c-cpm: Fix build by adding of_address.h and of_irq.h
> 

Thanks, I'll pick it up when it hits Linus's tree.

greg k-h
