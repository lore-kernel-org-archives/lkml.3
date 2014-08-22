Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875AbaHVQ7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:59:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32888 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbaHVQ7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:59:45 -0400
X-AuditID: cbfee61a-f79e46d00000134f-00-53f776fffa51
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Mark Brown <broonie@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 0/5] usb: phy: samsung: remove old USB PHY code
Date: Fri, 22 Aug 2014 18:59:00 +0200
Message-id: <1408726745-31135-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e+xgO7/su/BBosWm1psnLGe1eLg/XqL
	Tdevs1q0XTnIbvHj9QU2i94FV9ksLjztYbM42/SG3eLyrjlsFjPO72OyWLSsldmB2+POtT1s
	Hn1bVjF6HL+xncnj8ya5AJYoLpuU1JzMstQifbsEroxz+9eyFEznrdi0eA1jA+NKri5GTg4J
	AROJzU/Ps0PYYhIX7q1n62Lk4hASWMQo8WblbWaQhJBAF5PEqfcqIDabgJXExPZVjCC2iICa
	RM/irYwgDcwC95kkNj88zQqSEBZwkrg1fQ3YVBYBVYktt56ygdi8Ah4Sv+YeYITYpijR/WwC
	2wRG7gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgkPomdQOxpUNFocYBTgYlXh4DTy+
	BwuxJpYVV+YeYpTgYFYS4ZUuBArxpiRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgkkJ5Ykpqd
	mlqQWgSTZeLglGpgDAx6W83ov+dlp9NjtdyJK9k2nHB5EOS8PilVc85EG+51L/KYnEWed2Tl
	rVo2aW7wv3LRDsc8D48bd2uq/uk+K3TXT8tR+sfy9K/XySL25ZWMpf/8qrbd8ctb/f7DnO0r
	XGbf9dSpnMrAMJPz/7yUCO5D+wV03Wf59eqlPVn3a9vSCcrm/6cpK7EUZyQaajEXFScCAHyA
	sDQdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series removes the old Samsung USB PHY drivers that
got replaced by the new ones using the generic PHY layer.

Depends on:
- v3.17-rc1 branch of Linus' kernel

Changes since v1 (https://lkml.org/lkml/2014/8/14/241):
- rebased on v3.17-rc1 kernel
- added Acked-by-s from Kishon Vijay Abraham I
- added Reviewed-by-s from Vivek Gautam and Jingoo Han

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


Bartlomiej Zolnierkiewicz (5):
  ARM: dts: remove old USB2 PHY node hook for Arndale
  ARM: dts: remove old USB2 PHY node for Exynos5250
  usb: phy: samsung: remove old USB 2.0 PHY driver
  usb: phy: samsung: remove old USB 3.0 PHY driver
  usb: phy: samsung: remove old common USB PHY code

 arch/arm/boot/dts/exynos5250-arndale.dts     |   4 -
 arch/arm/boot/dts/exynos5250.dtsi            |  15 -
 drivers/usb/phy/Kconfig                      |  23 --
 drivers/usb/phy/Makefile                     |   3 -
 drivers/usb/phy/phy-samsung-usb.c            | 241 ------------
 drivers/usb/phy/phy-samsung-usb.h            | 349 -----------------
 drivers/usb/phy/phy-samsung-usb2.c           | 541 ---------------------------
 drivers/usb/phy/phy-samsung-usb3.c           | 350 -----------------
 include/linux/platform_data/samsung-usbphy.h |  27 --
 9 files changed, 1553 deletions(-)
 delete mode 100644 drivers/usb/phy/phy-samsung-usb.c
 delete mode 100644 drivers/usb/phy/phy-samsung-usb.h
 delete mode 100644 drivers/usb/phy/phy-samsung-usb2.c
 delete mode 100644 drivers/usb/phy/phy-samsung-usb3.c
 delete mode 100644 include/linux/platform_data/samsung-usbphy.h

-- 
1.8.2.3

