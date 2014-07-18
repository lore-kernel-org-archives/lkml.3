Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030414AbaGRQdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:33:50 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:58082 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935023AbaGRQdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:33:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chanwoo Choi <cwchoi00@gmail.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, jic23@kernel.org,
        naveen krishna <ch.naveen@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        pawel.moll@arm.com, Mark Rutland <mark.rutland@arm.com>,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        rdunlap@infradead.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, linux-iio@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCHv6 3/4] iio: devicetree: Add DT binding documentation for Exynos3250 ADC
Date: Fri, 18 Jul 2014 18:33:06 +0200
Message-ID: <5835825.JtcDoyOP8b@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAGTfZH3cH-QFMbfTWJJfTPTRT-Bij2TW=6CH_Yy-GaZqZvn-Xg@mail.gmail.com>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com> <6104032.PNRl85V92G@wuerfel> <CAGTfZH3cH-QFMbfTWJJfTPTRT-Bij2TW=6CH_Yy-GaZqZvn-Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bdEDxTKT93HqH+nFhUm0bYFUcOTrOgVHi+XF3JnBqGc
 u7dc4xG8Yz3IKXdZ4M2TZECqh7pLUJNAIG5stuklkjvryCggXH
 ly0uLjBcp2IPWO01yqWEwlpGmrTNL/v5a4nnDESRahsS58vtQH
 XlIlfcCG4K9Po18ZTHLV6cPDe72eCCiGRCkXCOIJ/r+PYki09A
 mBJTTPgWp38Khe0Z0+va8lXDyz3uc+Kxk6lMqGidx4IqIyVZ75
 KNzg68bo2HNjjxRej1Y3R6S/k2vSAAieLRo9a1dMx4iGVU7epE
 zMLrIo7ylQh1zFNbEvnVxMwyq5AhDt5TWYmhDyWzuiLCCZ7jfg
 DZqoDCb1cQJLRa9Dix8I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 July 2014 01:23:15 Chanwoo Choi wrote:
> If don't add new compatible including specific exynos version,
> I would add new 'adc-needs-sclk' property with existing 'exynos-adc-v2'
> compatible name.
> 
> 
> Dear Naveen, Tomasz,
> 
> If existing exynos-adc driver add just one property for 'sclk_adc'
> as following, exynos-adc could not include the exynos version
> in compatible name.
> 
> I need your opinion about it.
> 
>                 adc: adc@126C0000 {
>                         compatible = "samsung,exynos-adc-v2";
>                         reg = <0x126C0000 0x100>, <0x10020718 0x4>;
>                         interrupts = <0 137 0>;
>                         clock-names = "adc", "sclk_adc";
>                         clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
> +                        adc-needs-sclk;
>                         #io-channel-cells = <1>;
>                         io-channel-ranges;
>                 }

How about just making it an optional clock? That would be much
easier because then you can simply see if the clock itself is
there and use it, or otherwise ignore it.

	Arnd
