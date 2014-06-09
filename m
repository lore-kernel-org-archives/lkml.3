Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbaFIKQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:16:58 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48482 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaFIKQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:16:56 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-b5-539589956f0a
Message-id: <1402309011.17650.9.camel@AMDC1943>
Subject: Re: [PATCH 0/5] Add Maxim 77802 PMIC support
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org,
        Daniel Stone <daniels@collabora.com>
Date: Mon, 09 Jun 2014 12:16:51 +0200
In-reply-to: <1402306670-17041-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1402306670-17041-1-git-send-email-javier.martinez@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t/xa7pTO6cGG1xeq2yx5OJVdoupD5+w
	WWzq38puMf/IOVaLs8sOslkc/V1g0bvgKpvF/a9HGS2+Xelgstj0+BqrxeVdc9gsZpzfx2Tx
	dMJFNotT1z+zWZzuZrWYfvwtq0Xf2ktsDoIesxsusnj8fX6dxWPH3SWMHjtn3WX32LSqk83j
	zrU9bB7zTgZ6bF5S73HlRBOrR9+WVYwe0+f9ZPL4vEkugCeKyyYlNSezLLVI3y6BK+PjmrdM
	Bc/5K/adaGFrYDzB08XIySEhYCJx5uEGdghbTOLCvfVsXYxcHEICSxkljrQ0sEA4nxkllsw/
	CFbFK6AvsezMRiYQW1jAVOLpvj/MIDabgLHE5uVL2EBsEQE7iRurHzKDNDMLPGCReLL8FViC
	RUBVov/1a7BBnAIBEquO7ASzhQT8Jd62vwerYRZQl5g0bxEzxEnKEvP2H2OCWCwo8WPyPRaI
	GnmJzWveMk9gFJiFpGUWkrJZSMoWMDKvYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAiJxa87
	GJceszrEKMDBqMTDm8A0NViINbGsuDL3EKMEB7OSCK9PDlCINyWxsiq1KD++qDQntfgQIxMH
	p1QDI6fS52hX7vaLocGygRyXTpz6uuf1mgTOt70/lk6cmPNn173IppuXGLI9MtmY/QoXHX8t
	qJg6/cXJep9QNe1jm72jlDY4TZ9w6NDB9j08wpqf5i7KD5sWdubGo8+p7lzsMop3mL7/+tlw
	TiRRhPOvWujSY+cPdObzKJz1Wb9bu/CX0P4HeXN/PlRiKc5INNRiLipOBACn+BmGowIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-06-09 at 11:37 +0200, Javier Martinez Canillas wrote:
> MAX77802 is a PMIC that contains 10 high efficiency Buck regulators,
> 32 Low-dropout (LDO) regulators, two 32kHz buffered clock outputs,
> a Real-Time-Clock (RTC) and a I2C interface to program the individual
> regulators, clocks and the RTC.
> 
> This series are based on drivers added by Simon Glass to the Chrome OS
> kernel and adds support for the Maxim 77802 Power Management IC, their
> regulators, clocks, RTC and I2C interface. It is composed of patches:
> 
> [PATCH 1/5] mfd: Add driver for Maxim 77802 Power Management IC
> [PATCH 2/5] regulator: Add driver for Maxim 77802 PMIC regulators
> [PATCH 3/5] clk: Add driver for Maxim 77802 PMIC clocks
> [PATCH 4/5] rtc: Add driver for Maxim 77802 PMIC Real-Time-Clock
> [PATCH 5/5] ARM: dts: Add max77802 device node for exynos5420-peach-pit
> 
> Patches 1-4 add support for the different devices and Patch 5 enables
> the MAX77802 PMIC on the Exynos5420 based Peach pit board.


Hi,

The main mfd, mfd irq, clk and rtc drivers look very similar to max77686
drivers. I haven't checked other Maxim drivers but I think there will be
a lot of similarities with them also. It is almost common for Maxim
chipsets to share components between each other.

I think there is no need in duplicating all that stuff once again in new
driver for another Maxim-almost-the-same-as-others-XYZ chipset. Just
merge it with max77686 (or other better candidate).

The only difference is in regulator driver. I am not sure whether this
is a result of differences in chip or differences in driver design.

Best regards,
Krzysztof



> Lee,
> 
> Patches 2-4 depend on Patch 1 so I think that it makes sense if you take
> 1-4 through your mfd tree once the relevant maintainers ack the drivers
> added to the other subsystems (regulator, clk and rtc).
> 
> Patch 5 can go through Kukjin tree since is just DTS changes.
> 
> Thanks a lot and best regards,
> Javier



