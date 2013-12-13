Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab3LMJ3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 04:29:33 -0500
Received: from gloria.sntech.de ([95.129.55.99]:36460 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab3LMJ3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 04:29:30 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: kgene@kernel.org
Subject: Re: [PATCH] ARM: S3C24XX: Fix configuration of gpio port sizes on S3C24XX.
Date: Fri, 13 Dec 2013 10:29:19 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "=?iso-8859-1?q?=27Jos=E9_Miguel?= =?iso-8859-1?q?_Gon=E7alves=27?=" 
	<jose.goncalves@inov.pt>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1378889173-7437-1-git-send-email-jose.goncalves@inov.pt> <52AA6909.8050200@inov.pt> <0bc301cef7e5$319ac0c0$94d04240$@kernel.org>
In-Reply-To: <0bc301cef7e5$319ac0c0$94d04240$@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201312131029.20078.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 13. Dezember 2013, 10:24:59 schrieb kgene@kernel.org:
> José Miguel Gonçalves wrote:
> > On 27-09-2013 15:17, Linus Walleij wrote:
> > > On Wed, Sep 11, 2013 at 10:46 AM, José Miguel Gonçalves
> > > 
> > > <jose.goncalves@inov.pt> wrote:
> > >> Some GPIO line limits are incorrectly set which, for instance,
> > >> does not allow nRTS1 (GPH11) configuration on a S3C2416 chip.
> > >> 
> > >> Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>
> > >> ---
> > >> 
> > >>   arch/arm/mach-s3c24xx/include/mach/gpio.h |   10 +++++-----
> > > 
> > > OK but grrrr!
> > > 
> > > What needs to happen to the s3c24xx is to get rid of this file.
> > > 
> > > - Define ARCH_NR_GPIOS in arch/arm/Kconfig entry
> > > 
> > >    ARCH_NR_GPIO like everyone else
> > > 
> > > - Get rid of the config symbol NEED_MACH_GPIO_H
> > > 
> > > -  Move this file down into arch/arm/mach-s3c24xx/s3c24xx-gpio.h
> > > 
> > >    or whatever and make it local...
> > > 
> > > I will try to do this myself if noone else helps out, so I'd like to
> > > carry this patch in the GPIO tree provided I can get an ACK from
> > > the S3C24xx maintainer. Tomasz, is that you or Kukjin?
> > > 
> > > (BTW the above maybe goes for S3c64xx as well .. and S5P
> > > oh well I will get to it.)
> > 
> > Was this patch forgotten?
> 
> Hi Jose,
> 
> Sorry about missing your patch. It's my fault :( and as you know, at this
> moment the file will be removed by Linus' patch...
> 
> Anyway, let me look at the Samsung patches closely ;)

The comment that is changed in the header is removed by Linus' patch, but the 
change to the gpio driver is still relevant for the time being I'd think.


Heiko
