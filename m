Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaH1W7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 18:59:55 -0400
Received: from gloria.sntech.de ([95.129.55.99]:42316 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbaH1W7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 18:59:52 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Caesar Wang <caesar.wang@rock-chips.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, rui.zhang@intel.com,
        grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, dtor@chromium.org, zyw@rock-chips.com,
        addy.ke@rock-chips.com, dmitry.torokhov@gmail.com,
        zhaoyifeng <zyf@rock-chips.com>, linux-iio@vger.kernel.org,
        Courtney Cavin <courtney.cavin@sonymobile.com>
Subject: Re: [PATCH v3 1/4] thermal: rockchip: add driver for thermal
Date: Fri, 29 Aug 2014 01:01:40 +0200
Message-ID: <4669530.jbaGRecGMH@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <53FF84C4.9080902@rock-chips.com>
References: <1409187562-12370-1-git-send-email-caesar.wang@rock-chips.com> <4488604.oBeB6it8Vr@wuerfel> <53FF84C4.9080902@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Caesar,

Am Freitag, 29. August 2014, 03:36:36 schrieb Caesar Wang:
> Arnd & Heiko & Eduardo,
> 
> OK. Maybe you are right.
> 
> This driver should be put into drivers/iio/adc/* ,
> Anyway,I will re-edit it ASAP.

I pieced together an example on how this could look, if you need inspiration.

As I've written, the tsadc on the rk3066 is simply another saradc, so it was 
easy to build a usable example with it, which you can find in my 
devel/workbench branch [0].

Things to note, the adc values are converted to voltages instead of the 
"code"-values listed in the TRM [formula: (code * vref_mv)  >> 12)] and the 
temperatures are listed in millikelvin (C+273150) as expected by the pending 
iio-thermal driver.


@Courtney: (not sure how to reply to the old thread from february)
the only issue I found was the unit of the voltages. The binding doc lists 
them as uV, while iio (and the driver itself) expect to use mV.

Otherwise the iio-thermal driver:
Tested-by: Heiko Stuebner <heiko@sntech.de>


Heiko



[0] https://github.com/mmind/linux-rockchip/commits/devel/workbench
(recent commits till "thermal: add generic IIO channel thermal sensor driver")



> 在 2014/8/29 0:16, Arnd Bergmann 写道:
> > On Thursday 28 August 2014 18:11:43 Heiko Stübner wrote:
> >> Am Donnerstag, 28. August 2014, 10:37:35 schrieb Eduardo Valentin:
> >>>> On the driver side, I believe the correct way to deal with this setup
> >>>> is to split your driver into a generic
> >>>> drivers/iio/adc/rockchips-tsadc.c
> >>>> file, and a smaller thermal driver that uses the iio in-kernel
> >>>> interfaces,
> >>>> ideally one that is independent of the underlying hardware and can
> >>>> work on any ADC implementation.
> >>> 
> >>> Agreed. If you can write such interface and make your driver to work in
> >>> such way, that would be great.
> >> 
> >> But I currently don't see how you would model the temperature handling
> >> parts from a generic thermal driver to a generic adc driver for the
> >> rk3288-tsadc.
> >> 
> >> I guess the general temperature irq handling would use iio-triggers? But
> >> how does the target temperature get into the TSADC_COMP1_INT register.
> >> 
> >> Also when getting the temperature, Caesar's driver compares it to its
> >> trip
> >> points and sets the next trip point depending on the current temperature
> >> (passive <-> critical) in rockchip_get_temp.
> >> 
> >> Maybe there is some completely easy way for this, but currently I don't
> >> see
> >> it.
> > 
> > Eduardo earlier today replied to an email about a generic driver for
> > thermal, which was posted in February but hasn't been merged.
> > See https://lkml.org/lkml/2014/2/5/810
> > 
> > There may be a newer version of this patch, which I haven't found.
> > 
> > 	Arnd

