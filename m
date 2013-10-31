Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab3JaHqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 03:46:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14482 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3JaHqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 03:46:39 -0400
X-AuditID: cbfee68d-b7fa16d0000029b0-ee-52720add7178
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        gregkh@linuxfoundation.org, kishon@ti.com, kgene.kim@samsung.com,
        k.debski@samsung.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        balbi@ti.com, jwerner@chromium.org, jg1.han@samsung.com
Subject: [PATCH RFC 0/4] Add Exynos5 USB 3.0 phy driver based on generic PHY
 framework
Date: Thu, 31 Oct 2013 13:15:40 +0530
Message-id: <1383205544-32244-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42JZI2JSpXuXqyjI4NRPYYuD9+st5h85x2rR
	vHg9m8XlhZdYLToOPWay+PH6AptF74KrbBYXnvawWWx6fI3VYmHbEhaLy7vmsFnMOL+PyWLR
	slZmi8Nv2lkt1s94zeLA7zG74SKLx/65a9g9Ni+p9+jbsorR4/iN7UwenzfJBbBFcdmkpOZk
	lqUW6dslcGU8fT2DpeArT8XGbV/ZGxhvcHYxcnJICJhIvLo1jR3CFpO4cG89WxcjF4eQwFJG
	iZm/3wM5HGBFF/cYQMQXMUrcXryHFcKZwiRxZMpENpBuNgFdiaa3uxhBbBEBB4klS++ATWIW
	OMQksXTvXBaQhLBAhMTmW5fAGlgEVCU2/FnIBGLzCnhIbDpxlwXiDAWJN7efMYM0SwgcY5f4
	MPMKE0SDgMS3yYdYIE6Sldh0gBmiXlLi4IobLBMYBRcwMqxiFE0tSC4oTkovMtQrTswtLs1L
	10vOz93ECIyH0/+e9e5gvH3A+hBjMtC4icxSosn5wHjKK4k3NDYzsjA1MTU2Mrc0I01YSZw3
	6WFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG45mqO89tlnpdJ/7h2rVpM+PDv+a4Byrd
	8J2W2yk177nYk7g9hSe8dyyaMStgzYyVs1ZPebF89/6EExfaPrqV8YTLPWzdcFv4z2z1vx1y
	N/TW5jrvs7R7u8rR0yAl9F17Hv/ULcoTVssvDWZtFT3wnWlx4IwF676v5pJc6cs6TXKnUdbE
	lSLSe5RYijMSDbWYi4oTAWPoSlydAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t9jAd27XEVBBge6OSwO3q+3mH/kHKtF
	8+L1bBaXF15iteg49JjJ4sfrC2wWvQuusllceNrDZrHp8TVWi4VtS1gsLu+aw2Yx4/w+JotF
	y1qZLQ6/aWe1WD/jNYsDv8fshossHvvnrmH32Lyk3qNvyypGj+M3tjN5fN4kF8AW1cBok5Ga
	mJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0spJCWWJOKVAo
	ILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx4+nrGSwFX3kqNm77yt7AeIOzi5GDQ0LA
	ROLiHoMuRk4gU0ziwr31bF2MXBxCAosYJW4v3sMK4UxhkjgyZSIbSBWbgK5E09tdjCC2iICD
	xJKld8A6mAUOMUks3TuXBSQhLBAhsfnWJbAGFgFViQ1/FjKB2LwCHhKbTtxlgVinIPHm9jPm
	CYzcCxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER9szqR2MKxssDjEKcDAq8fAy6BYG
	CbEmlhVX5h5ilOBgVhLh3XYSKMSbklhZlVqUH19UmpNafIgxGWj7RGYp0eR8YCLIK4k3NDYx
	NzU2tTSxMDGzJE1YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbGPUos1/ZO89wuydjJ7y43
	edWh/wXLhEx0/z6aWPX7ltZZ2w6ppy0XzEPk38wqY0k4f8f1QbJCKbv8BC3m5Nt2FQzHmqXu
	sCyVbeaZWetofybrXva9vZMOVz/hWdD9ZVL36xP7LsZ/DVq54qbI4e9f3x2WXffh83TXg48P
	zpyiUzn3MOcbf4bDikosxRmJhlrMRcWJADw9f976AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a phy driver for USB 3.0 PHY controller present on Exynos5
series of SoCs alongwith DWC3 controller for USB 3.0 operations.

This driver is inline with Kamil's USB 2.0 phy driver. [1]
Few functions used to translate ref clock rate are common to
Kamil's changes. So we can figure out how to re-use them across
these drivers.

Theses patches are based on usb-next branch and tested with
Kishon's patches for adapting DWC3 to generic phy framework, [2]
on smdk5250 as well as smdk5420 board.

[1] [PATCH 0/5] phy: Add new Exynos USB PHY driver
    https://lkml.org/lkml/2013/10/25/230
[2] [PATCH v2 1/7] usb: dwc3: get "usb_phy" only if the platform indicates the presence of PHY's
    (http://www.spinics.net/lists/linux-usb/msg95733.html)
    [PATCH v2 2/7] usb: dwc3: adapt dwc3 core to use Generic PHY Framework
    (http://www.spinics.net/lists/linux-usb/msg95734.html)

Vivek Gautam (4):
  phy: Add new Exynos5 USB 3.0 PHY driver
  dt: exynos5250: Enable support for generic USB 3.0 phy
  dt: exynos5420: Enable support for USB 3.0 PHY controller
  dt: exynos5420: Enable support for DWC3 controller

 .../devicetree/bindings/phy/samsung-phy.txt        |   20 +
 arch/arm/boot/dts/exynos5250.dtsi                  |   17 +-
 arch/arm/boot/dts/exynos5420.dtsi                  |   50 ++
 drivers/phy/Kconfig                                |    7 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-exynos5-usb3.c                     |  562 ++++++++++++++++++++
 6 files changed, 646 insertions(+), 11 deletions(-)
 create mode 100644 drivers/phy/phy-exynos5-usb3.c

-- 
1.7.6.5

