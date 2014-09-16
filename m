Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaIPJDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:03:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51624 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaIPJDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:03:37 -0400
X-AuditID: cbfee690-f79ce6d00000115a-9b-5417fce63a11
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, cpgs@samsung.com, grundler@chromium.org,
        jic23@kernel.org
Subject: [PATCH v2 0/3] iio: exynos-adc: use syscon instead of ioremap
Date: Tue, 16 Sep 2014 14:28:48 +0530
Message-id: <1410857931-4980-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkTvfZH/EQgyVvDS1eHtK0uP7lOavF
	/CPnWC2aF69ns3h15AeTxYOmVUwWSybPZ7WYd+Qdi8XlXXPYLGac38dksWjbf2YHbo/ZDRdZ
	PHbOusvusWlVJ5vH/rlr2D2WvDnE6tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZ114cYS34
	z1lxvqWbuYHxAHsXIyeHhICJxMwLvawQtpjEhXvr2boYuTiEBJYySjQ8aGGDKfp3+SQTRGI6
	o8T+uy9YIZx+Jonf9yYyglSxCZhJHFy0GmysiECcxIfL/ewgRcwC+xklXr/eD5YQFnCT+Dvn
	JwuIzSKgKnFwyxkmEJtXwEXiyrnLQIM4gNYpSMyZZAOxeR27xKsLghDlAhLfJh9igSiRldh0
	gBmiRFLi4IobLBMYBRcwMqxiFE0tSC4oTkovMtErTswtLs1L10vOz93ECAz40/+eTdjBeO+A
	9SFGAQ5GJR5ej0fiIUKsiWXFlbmHGE2BNkxklhJNzgfGVV5JvKGxmZGFqYmpsZG5pZmSOO9r
	qZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhiXTK1sY1zZajSzQyPvREdiqs7pf9bPbs+T
	77yY6rhovcHrCp5Ziz8FJyQozzj8IfmEcM7jPyIi99JKtY5flTvTY/zvfPjx7KlCUi8ac9hO
	m3qpCK7/ddFz53MNhi/i5xbs53R0V5o59/cZx0/W2yKvuLMfMlf69+kXQ87/3Tv3Rm6Z0eD/
	btFvJZbijERDLeai4kQAIMoRTHMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t9jQd1nf8RDDDr+q1u8PKRpcf3Lc1aL
	+UfOsVo0L17PZvHqyA8miwdNq5gslkyez2ox78g7FovLu+awWcw4v4/JYtG2/8wO3B6zGy6y
	eOycdZfdY9OqTjaP/XPXsHsseXOI1aNvyypGj8+b5ALYoxoYbTJSE1NSixRS85LzUzLz0m2V
	vIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAjlRSKEvMKQUKBSQWFyvp22GaEBripmsB
	0xih6xsSBNdjZIAGEtYwZlx7cYS14D9nxfmWbuYGxgPsXYycHBICJhL/Lp9kgrDFJC7cW8/W
	xcjFISQwnVFi/90XrBBOP5PE73sTGUGq2ATMJA4uWg3WLSIQJ/Hhcj87SBGzwH5Gidev94Ml
	hAXcJP7O+ckCYrMIqEoc3HIGbAWvgIvElXOXgQZxAK1TkJgzyWYCI/cCRoZVjKKpBckFxUnp
	uUZ6xYm5xaV56XrJ+bmbGMER9Ux6B+OqBotDjAIcjEo8vB6PxEOEWBPLiitzDzFKcDArifA+
	+AQU4k1JrKxKLcqPLyrNSS0+xGgKtHwis5Rocj4w2vNK4g2NTcxNjU0tTSxMzCyVxHkPtloH
	CgmkJ5akZqemFqQWwfQxcXBKNTCWBEz3af7yWLYpLmaNjkLrwesVJ21eJ25cMvnhr67Ufy8T
	9FomWm0rl5x4Q4XNZptgn8nry1N6XqxXKLzbsf7Hw/d/Yv5n7bCIznQ4Grih8kPSyd2z5JV/
	7f2u43CZn21Wt9Si/RtU/OrXKsjfkj271evgn9zpsvM9FI9ZVeUytfVUrfjqrxiqxFKckWio
	xVxUnAgAeOndeL4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
1. Rebased on top of togreg branch of IIO git.

This patch set does the following
1. Use the syscon and Regmap API instead of ioremappaing the
   ADC_PHY register from PMU.
2. Updates the Documentation in exynos-adc.txt with syscon phandle
   for the ADC nodes.
3. Updates the Dts files for Exynos3250, Exynos4x12, Exynos5250,
   Exynos5420 with the syscon phandle.

Tested on Exynos5420 based Peach PIT and Exynos5800 based Peach PI
by verifying sysfs entries provided by HWMON based NTC thermistors.

Tested-By for Exynos3250, Exynos4x12 would be appreciated.

Naveen Krishna Chatradhi (3):
  iio: exyno-adc: use syscon for PMU register access
  Documentation: dt-bindings: update exynos-adc.txt with syscon handle
  ARM: dts: exynos: Add sysreg phandle to ADC node

 .../devicetree/bindings/arm/samsung/exynos-adc.txt |    9 ++++--
 arch/arm/boot/dts/exynos3250.dtsi                  |    3 +-
 arch/arm/boot/dts/exynos4x12.dtsi                  |    3 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |    3 +-
 arch/arm/boot/dts/exynos5420.dtsi                  |    3 +-
 drivers/iio/adc/exynos_adc.c                       |   30 ++++++++++++++------
 6 files changed, 36 insertions(+), 15 deletions(-)

-- 
1.7.9.5

