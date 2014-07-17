Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbaGQLX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:23:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26591 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881AbaGQLXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:23:25 -0400
X-AuditID: cbfee690-b7fb56d000003439-bb-53c7b22aee57
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, cpgs@samsung.com, grundler@chromium.org,
        jic23@kernel.org
Subject: [PATCH 0/4 v2] iio: exynos-adc: use syscon instead of ioremap
Date: Thu, 17 Jul 2014 16:49:49 +0530
Message-id: <1405595993-16661-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWyRsSkTldr0/Fgg19HzC1eHtK0uP7lOavF
	/CPnWC2aF69ns3h15AeTxYOmVUwWSybPZ7WYd+Qdi8XlXXPYLGac38dksWjbf2YHbo/ZDRdZ
	PHbOusvusWlVJ5vH/rlr2D2WvDnE6tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZfc1tjAX7
	BCreLNvB3MDYwtvFyMkhIWAi0TBxDSOELSZx4d56ti5GLg4hgaWMEmuedbPCFJ0428oOkZjO
	KDHxyS92kISQQD+TxP67wSA2m4CZxMFFq8HiIgJxEh8u94M1MAvsZ5R4/Xo/WEJYwE3iy+KF
	bCA2i4CqxNw/98DivAKuEjf2bAWKcwBtU5CYM8kGpFdCYB27xNmexawQ9QIS3yYfYoGokZXY
	dIAZ4jhJiYMrbrBMYBRcwMiwilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMw4E//ezZhB+O9
	A9aHGJOBxk1klhJNzgdGTF5JvKGxmZGFqYmpsZG5pRlpwkrivGqPkoKEBNITS1KzU1MLUovi
	i0pzUosPMTJxcEo1MNo2n436p+JWynoj/4OwUnzVz0P/Gt6kLJZn5hX5U5W4ufGx7Ge7asl3
	wveKd/eL293e5FRYUxagX3Oh/8DHrlm9d7f4SXZM2/Bi2dMmYZ4dq7teruwunC6/jOnNgm/G
	v0o1Qkt9z+901pnGMbVIgvuHHuObNXN2Sc8W31z0OPV90oqofwFys5VYijMSDbWYi4oTAbkY
	KsWOAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jQV2tTceDDaa+1bd4eUjT4vqX56wW
	84+cY7VoXryezeLVkR9MFg+aVjFZLJk8n9Vi3pF3LBaXd81hs5hxfh+TxaJt/5kduD1mN1xk
	8dg56y67x6ZVnWwe++euYfdY8uYQq0ffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2Tmpdsq
	eQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHamkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxhzOhrbmMs2CdQ8WbZDuYGxhbeLkZODgkBE4kTZ1vZIWwxiQv31rN1
	MXJxCAlMZ5SY+OQXWEJIoJ9JYv/dYBCbTcBM4uCi1WBxEYE4iQ+X+9lBGpgF9jNKvH69Hywh
	LOAm8WXxQjYQm0VAVWLun3tgcV4BV4kbe7YCxTmAtilIzJlkM4GRewEjwypG0dSC5ILipPRc
	Q73ixNzi0rx0veT83E2M4Hh6JrWDcWWDxSFGAQ5GJR7ehNZjwUKsiWXFlbmHGCU4mJVEeLd1
	HQ8W4k1JrKxKLcqPLyrNSS0+xGgKtHwis5Rocj4w1vNK4g2NTcxNjU0tTSxMzCyVxHkPtFoH
	CgmkJ5akZqemFqQWwfQxcXBKNTBuWrGQlSVqt2tEUIve24Zfe1cu3vtWbONL8ZJPS2TtpjvN
	0d51ldX01B0T9Q8HZsqkxlW0Ch/P/rJbb/HXpT8nLw5JrDjd5mOhxVg/LcXrtoaR64SpD+Y+
	0PyaGfK1LerNp3TbHIYTV5kUuJ9cUdM+usl4adCJg/n9K5LPmMzve3JqjutZ7rl8SizFGYmG
	WsxFxYkAEqUreL0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Syscon is a regmap based framework to help various drivers access misc
bits in registers which does not belong to another module.
For example, Power Module, SYSREGs.

With syscon, ADC can use generic regmap API to access
registers of PMU which are registered into syscon.
 
This patch does the following
1. Use the syscon and Regmap API instead of ioremappaing the
   ADC_PHY register from PMU.
2. Moves the exynos-adc.txt from bindings/arm/samsung/
   to bindings/iio/adc/.
3. Updates the Documentation in exynos-adc.txt with syscon phandle
   for the ADC nodes.
4. Updates the Dts files for Exynos3250, Exynos4x12, Exynos5250,
   Exynos5420 with the syscon phandle.

Tested on Exynos5420 based Peach PIT and Exynos5800 based Peach PI
by verifying sysfs entries provided by HWMON based NTC thermistors.

Tested-By for Exynos3250, Exynos4x12 would be appreciated.

Changes since v1:
Adding syscon description in commit message

Rebased on top of v5 version of ADC for exynos3250 from Changwoo.
iio: adc: exynos_adc: Support Exynos3250 ADC and code clean
https://lkml.org/lkml/2014/6/27/16

Naveen Krishna Chatradhi (4):
  iio: exyno-adc: use syscon for PMU register access
  Documentation: dt-bindings: move exynos-adc.txt to more iio/adc/
  Documentation: dt-bindings: update exynos-adc.txt with syscon handle
  ARM: dts: exynos: Add sysreg phandle to ADC node

 .../devicetree/bindings/arm/samsung/exynos-adc.txt |   82 ------------------
 .../devicetree/bindings/iio/adc/exynos-adc.txt     |   87 ++++++++++++++++++++
 arch/arm/boot/dts/exynos3250.dtsi                  |    3 +-
 arch/arm/boot/dts/exynos4x12.dtsi                  |    3 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |    3 +-
 arch/arm/boot/dts/exynos5420.dtsi                  |    3 +-
 drivers/iio/adc/exynos_adc.c                       |   29 +++++--
 7 files changed, 115 insertions(+), 95 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
 create mode 100644 Documentation/devicetree/bindings/iio/adc/exynos-adc.txt

-- 
1.7.9.5

