Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaH1QRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 12:17:30 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:51653 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaH1QR0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 12:17:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Eduardo Valentin <edubezval@gmail.com>,
        Caesar Wang <caesar.wang@rock-chips.com>, rui.zhang@intel.com,
        grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, dtor@chromium.org, zyw@rock-chips.com,
        addy.ke@rock-chips.com, dmitry.torokhov@gmail.com,
        zhaoyifeng <zyf@rock-chips.com>, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH v3 1/4] thermal: rockchip: add driver for thermal
Date: Thu, 28 Aug 2014 18:16:27 +0200
Message-ID: <4488604.oBeB6it8Vr@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3440260.edal29kzlR@diego>
References: <1409187562-12370-1-git-send-email-caesar.wang@rock-chips.com> <20140828143733.GA18084@developer> <3440260.edal29kzlR@diego>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:WZjntEzkBOmwDYRFSK481A9YFD6XeVEBxhBh09EL8rI
 RpRNi9YkBfkTBkORiPdyvBabWcdNKa89xAxvUs8ptXWivOzEq3
 Ykf033QciseiU3TZ/qcNkMEvRj2+1+OAqBg6I0ZaWgX6YgYPw3
 C9WhIhYi8yziCl5vxdn+lq65pOPAnnT75JRQXsnbBaFzVJU5Z5
 Z8UeAqzfHuPDSsYdvsleDAPDzu4o75Bp5luckk2LAsPt5qN1yE
 bWJhYDNk5C7nPrwtVHi+/eg9pnKZoI4j6C9XP4FYw8+Wxgv+Bm
 huEuwGyRPBV5WS6hc1bk2Qaoclqz9RIQlmfCMsaCNLQu3yTVE+
 375Xf7VdtAnhZVwatGpo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2014 18:11:43 Heiko Stübner wrote:
> Am Donnerstag, 28. August 2014, 10:37:35 schrieb Eduardo Valentin:
> > > On the driver side, I believe the correct way to deal with this setup
> > > is to split your driver into a generic drivers/iio/adc/rockchips-tsadc.c
> > > file, and a smaller thermal driver that uses the iio in-kernel interfaces,
> > > ideally one that is independent of the underlying hardware and can
> > > work on any ADC implementation.
> > 
> > Agreed. If you can write such interface and make your driver to work in
> > such way, that would be great.
> 
> But I currently don't see how you would model the temperature handling parts 
> from a generic thermal driver to a generic adc driver for the rk3288-tsadc.
> 
> I guess the general temperature irq handling would use iio-triggers? But how 
> does the target temperature get into the TSADC_COMP1_INT register.
> 
> Also when getting the temperature, Caesar's driver compares it to its trip 
> points and sets the next trip point depending on the current temperature 
> (passive <-> critical) in rockchip_get_temp.
> 
> Maybe there is some completely easy way for this, but currently I don't see 
> it.

Eduardo earlier today replied to an email about a generic driver for
thermal, which was posted in February but hasn't been merged.
See https://lkml.org/lkml/2014/2/5/810

There may be a newer version of this patch, which I haven't found.

	Arnd
