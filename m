Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448Ab3BXXQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 18:16:56 -0500
Received: from gloria.sntech.de ([95.129.55.99]:39376 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758716Ab3BXXQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 18:16:54 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] i2c: s3c2410: check for NULL pinctrl handle
Date: Mon, 25 Feb 2013 00:16:49 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>
References: <201302231855.47560.heiko@sntech.de> <1366216.NzXQfD1BG7@flatron> <CACRpkdbfQOeJ3u8_UvgVMRyu_MMmOZD0tjQT+qNr9iOEpAHLWQ@mail.gmail.com>
In-Reply-To: <CACRpkdbfQOeJ3u8_UvgVMRyu_MMmOZD0tjQT+qNr9iOEpAHLWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302250016.49773.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 24. Februar 2013, 23:39:44 schrieb Linus Walleij:
> On Sun, Feb 24, 2013 at 6:00 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> >> > Note that we are talking here about a temporary solution. The legacy
> >> > DT- based pin configuration will go away after all the DT-enabled
> >> > platforms using this driver get migrated to pin control and so will
> >> > the need to check if pin control is available.
> >> 
> >> So use AUXDATA, and you get a pdata for that driver?
> > 
> > Hmm, and then have some platform data passed statically and some parsed
> > from device tree?
> 
> This is done by several in-tree drivers today. It is even necessary for
> things like machine-specific callbacks.
> 
> > Not even saying that we are going towards getting rid of
> > auxdata, not adding further dependencies for it.
> 
> The other option is to do the non-temporary solution you are
> referring to below...
> 
> > Sorry, but this sounds more broken to me than checking the return value
> > of devm_pinctrl_get_select_default for NULL in the driver.
> 
> Both are bad solution, auxdata is less bad than trying to check
> struct pinctrl * handles for non-NULL, which has *never* been a
> good thing to do and should never have been merged in the first
> place.
> 
> (Maybe I ACKed that, then I was doing something stupid.)
> 
> > Still, all the platforms relying on the legacy DT GPIO support should
> > have been already migrated to pin control, so ideally instead of
> > "fixing" the drivers to continue supporting the deprecated method, such
> > platforms should be fixed.
> 
> I agree.

Fine by me ... I'll work on a pinctrl driver for s3c24xx then :-)


Heiko
