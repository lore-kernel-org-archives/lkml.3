Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491Ab3BYACs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 19:02:48 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:33030 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759413Ab3BYACr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 19:02:47 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Linus Walleij <linus.walleij@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH] i2c: s3c2410: check for NULL pinctrl handle
Date: Mon, 25 Feb 2013 01:02:43 +0100
Message-ID: <2474544.LLiqKSFeoG@flatron>
User-Agent: KMail/4.10 (Linux/3.8.0-gentoo; KDE/4.10.0; x86_64; ; )
In-Reply-To: <201302250016.49773.heiko@sntech.de>
References: <201302231855.47560.heiko@sntech.de> <CACRpkdbfQOeJ3u8_UvgVMRyu_MMmOZD0tjQT+qNr9iOEpAHLWQ@mail.gmail.com> <201302250016.49773.heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 25 of February 2013 00:16:49 Heiko Stübner wrote:
> Am Sonntag, 24. Februar 2013, 23:39:44 schrieb Linus Walleij:
> > On Sun, Feb 24, 2013 at 6:00 PM, Tomasz Figa <tomasz.figa@gmail.com> 
wrote:
> > >> > Note that we are talking here about a temporary solution. The
> > >> > legacy
> > >> > DT- based pin configuration will go away after all the DT-enabled
> > >> > platforms using this driver get migrated to pin control and so
> > >> > will
> > >> > the need to check if pin control is available.
> > >> 
> > >> So use AUXDATA, and you get a pdata for that driver?
> > > 
> > > Hmm, and then have some platform data passed statically and some
> > > parsed
> > > from device tree?
> > 
> > This is done by several in-tree drivers today. It is even necessary
> > for
> > things like machine-specific callbacks.
> > 
> > > Not even saying that we are going towards getting rid of
> > > auxdata, not adding further dependencies for it.
> > 
> > The other option is to do the non-temporary solution you are
> > referring to below...
> > 
> > > Sorry, but this sounds more broken to me than checking the return
> > > value
> > > of devm_pinctrl_get_select_default for NULL in the driver.
> > 
> > Both are bad solution, auxdata is less bad than trying to check
> > struct pinctrl * handles for non-NULL, which has *never* been a
> > good thing to do and should never have been merged in the first
> > place.
> > 
> > (Maybe I ACKed that, then I was doing something stupid.)
> > 
> > > Still, all the platforms relying on the legacy DT GPIO support
> > > should
> > > have been already migrated to pin control, so ideally instead of
> > > "fixing" the drivers to continue supporting the deprecated method,
> > > such
> > > platforms should be fixed.
> > 
> > I agree.
> 
> Fine by me ... I'll work on a pinctrl driver for s3c24xx then :-)

Good.

I belive that pinctrl-samsung driver can be easily used for s3c24xx, with 
minor modifications to remove some assumptions that are true for all the 
newer Samsung SoCs.

I'm currently working (in my free time) on pinctrl driver for s3c64xx (as 
a part of my DT-enablement work), so possibly some of the code I will 
create may be useful for s3c24xx as well.

Best regards,
Tomasz

