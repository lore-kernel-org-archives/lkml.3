Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaKZOYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:24:43 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:10264 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaKZOYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:24:40 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-ff-5475e2a5926f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 0/5] Fix Arndale Octa/Peach Pi boot on Audio subsystem clocks
Date: Wed, 26 Nov 2014 15:24:12 +0100
Message-id: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsVy+t/xK7pLH5WGGLxZa2GxccZ6Vov5R86x
	WrRdOchucfR3gcXrF4YW/Y9fM1s83fyYyeJs0xt2iyl/ljNZbHp8jdVi8/w/jBaXd81hs5hx
	fh+Txe3LvBZrj9xlt3g64SKbxeE37awWx2YsYbRYtesPo4OwR0tzD5vH3+fXWTx2zrrL7rFp
	VSebx51re9g8Ni+p9+jbsorR4/MmuQCOKC6blNSczLLUIn27BK6M93clC55wVcxbv4ytgfEA
	RxcjJ4eEgInEhst32SBsMYkL99aD2UICSxklbvwDquECsvuYJOa9WMQCkmATMJbYvHwJG0hC
	RGAFi8SuRb+YQRxmgXeMEuvPrAerEhYIkHi68x0ziM0ioCrxZv8adhCbV8BdYuLlflaIdXIS
	J49NZp3AyL2AkWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkjQft3BuPSY1SFGAQ5GJR7e
	G3ElIUKsiWXFlbmHGCU4mJVEeFPvlIYI8aYkVlalFuXHF5XmpBYfYmTi4JRqYJw5e9ueJ/vf
	nwovXf2o2UfY98YHleUNOXNYpBeZbuIS8Oz+lKU8+bfIRp3DgivS3t/ffv72pruKSU+YrUTj
	N7zXTVCxDZux9d97f+OK/S3Z3Rx+fJ2PXswo3rF34VpvyXpz/UkzfY/HtlRZ8kTu99tm7bGy
	0WZSX+Dxi6YOUcc8JytO363R/l6JpTgj0VCLuag4EQCF3LLyOAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Changes since v1
================
1. clocks-audss: Reimplement own clock register functions instead
   changing clk API. Minor fixes. (after idea from Tomasz Figa)
2. Add new patches: fix for pinctrl and minor fixes in clk-audss.

Description
===========
This patchset tries to solve dependency between AudioSS components
(clocks and GPIO) and main clock controller on Exynos platform.

This solves boot failure of Peach Pi/Pit and Arndale Octa [1].

Any access to memory of audss block (like checking if clock is enabled
or configuring GPIO) will hang if main audss clock is gated.

Tested on Arndale Octa board.

[1] http://www.spinics.net/lists/linux-samsung-soc/msg39331.html

Best regards,
Krzysztof Kozlowski


Krzysztof Kozlowski (3):
  clk: samsung: Fix clock disable failure because domain being gated
  pinctrl: exynos: Fix GPIO setup failure because domain clock being
    gated
  ARM: dts: exynos5420: Add clock for audss pinctrl

 .../bindings/pinctrl/samsung-pinctrl.txt           |   6 +
 arch/arm/boot/dts/exynos5420-pinctrl.dtsi          |   3 +
 drivers/clk/samsung/clk-exynos-audss.c             | 367 +++++++++++++++++++--
 drivers/pinctrl/samsung/pinctrl-samsung.c          | 110 +++++-
 drivers/pinctrl/samsung/pinctrl-samsung.h          |   2 +
 5 files changed, 446 insertions(+), 42 deletions(-)

-- 
1.9.1

