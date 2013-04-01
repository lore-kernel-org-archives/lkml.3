Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab3DAN5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:57:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12132 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758427Ab3DAN4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:56:55 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-ac-51599225902c
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com, kishon@ti.com,
        dianders@chromium.org, t.figa@samsung.com, p.paneri@samsung.com
Subject: [PATCH v3 00/11] usb: dwc3/xhci/phy: Enable runtime power management
Date: Mon, 01 Apr 2013 19:23:59 +0530
Message-id: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSpas6KTLQoKdL2uLg/XqLs8sOslk0
	L17PZtG74CqbxYWnPWwWl3fNYbOYvaSfxWLG+X1MFouWtTJbnN/SyWRxeMUBJovmE6eYLSb8
	vsBmsX7GaxYHPo8Fn6+we8xuuMjiMe9koMf+uWuAvLs/GD36tqxi9Dh+YzuTx+dNcgEcUVw2
	Kak5mWWpRfp2CVwZDV0fWQoOClc8Ov2QpYHxEH8XIyeHhICJROOtA4wQtpjEhXvr2boYuTiE
	BJYySjxbtZcJpujQqnfsEIlFjBIPVnxjgnCmMEn8XzaBHaSKTUBXountLqBRHBwiAnESmycI
	g4SZBbqYJJYeFQexhQV8JX5N2Aa2jUVAVeL8luVsIDavgIfEtc5PLBDLFCTe3H7GDDJfQuAU
	u8SDLS0sEA0CEt8mH2IBmS8hICux6QAzRL2kxMEVN1gmMAouYGRYxSiaWpBcUJyUXmSsV5yY
	W1yal66XnJ+7iREYF6f/PevfwXj3gPUhxmSgcROZpUST84FxlVcSb2hsZmRhamJqbGRuaUaa
	sJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxm5Fiwi3tq5nzqkdh+6o2jAUaFw1
	WnSr9eja/c+PKVVVxC8Sumf4t2sd785XHnKygrc+9Ab9U3PNn1v6RuDRpLVXKvr+Os/YqufB
	cfl544mOe1/CbvaxaGzIOWDlPV9Z+emGnTc63RbOvZT60/rypcc3Hglu+/JN1eNnkmzh2bmr
	jaeFRH/g/KPEUpyRaKjFXFScCACi5hJYoQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jAV3VSZGBBg33BSwO3q+3OLvsIJtF
	8+L1bBa9C66yWVx42sNmcXnXHDaL2Uv6WSxmnN/HZLFoWSuzxfktnUwWh1ccYLJoPnGK2WLC
	7wtsFutnvGZx4PNY8PkKu8fshossHvNOBnrsn7sGyLv7g9Gjb8sqRo/jN7YzeXzeJBfAEdXA
	aJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdLeSQlli
	TilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMaOh6yNLwUHhikenH7I0MB7i72Lk
	5JAQMJE4tOodO4QtJnHh3nq2LkYuDiGBRYwSD1Z8Y4JwpjBJ/F82AayKTUBXountLsYuRg4O
	EYE4ic0ThEHCzAJdTBJLj4qD2MICvhK/JmxjBLFZBFQlzm9ZzgZi8wp4SFzr/MQCsUxB4s3t
	Z8wTGLkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOumdSOxhXNlgcYhTgYFTi4Y24
	EBEoxJpYVlyZe4hRgoNZSYR3RWZkoBBvSmJlVWpRfnxRaU5q8SHGZKDtE5mlRJPzgQkhryTe
	0NjE3NTY1NLEwsTMkjRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYo9/e1dVUO7zOWTrB
	YFFapcYRkQ6L60cefDFMOLRe5/aqyF9rVIplpjzpUl7Kf+vG7M3rKu5ohRVVnjb+bcfMWTNf
	4mrjg36bde0p3+fPs3PjM6pdLWT3e7WM4Y8b78V0PNjm5UjuObrMiO3u53Wts/kZbvDeqvvw
	J7lnneK0F55q/y/VvfKtVGIpzkg01GIuKk4EAKSi8jP+AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-series enables runtime power management on xhci-plat,
dwc3-core, dwc3-exynos as well as on Samsung's USB 2.0 type and
USB 3.0 type PHYs.

Based on 'next' branch of Felipe Balbi's USB tree.

Changes from v2:
 - Using separate functions for USB PHY runtime power management, instead of
   using macros.
 - Adding 'pm_runtime_set_suspended()' api call in dwc3 core layer before
   enabling runtime pm. (Ideally, we should be explicitly make device
   'suspended' or 'active' before enabling runtime pm on it).
 - Checking return code for 'put_sync' and 'get_sync' of USB-PHYs when
   waking up or suspending them from dwc3 core's runtime_pm callbacks.
 - Removed buggy pm_runtime_put() calls from driver's (xhci, dwc3 and PHY)
   remove functions.
 - Adding a patch to enable runtime power management of Samsung's USB 2.0 PHY
   (usb: phy: samsung: Enable runtime power management on usb2phy)

Changes from v1:
 - Adding required PHY APIs to handle runtime power management
   instead of directly twiddling with phy->dev.
 - Handling runtime power management of usb PHYs in dwc3 core
   driver instead of in any glue layer.
 - Splitting the patch:
   [PATCH 4/4] usb: phy: samsung: Enable runtime power management on samsung-usb
   into required number to bifurcate functionality.

Vivek Gautam (11):
  usb: phy: Add APIs for runtime power management
  USB: dwc3: Adjust runtime pm to allow autosuspend
  usb: dwc3: Enable runtime pm only after PHYs are initialized
  usb: dwc3: Add runtime power management callbacks
  usb: dwc3: exynos: Enable runtime power management
  usb: xhci: Enable runtime pm in xhci-plat
  usb: phy: samsung: Enable runtime power management on usb2phy
  usb: phy: samsung: Enable runtime power management on usb3phy
  usb: phy: samsung: Add support for external reference clock
  usb: phy: samsung: Add support for PHY ref_clk gpio
  usb: phy: samsung: Add support for PHY refclk switching

 drivers/usb/dwc3/core.c            |   59 ++++++++++++++--
 drivers/usb/dwc3/dwc3-exynos.c     |   12 +++
 drivers/usb/host/xhci-plat.c       |    6 ++
 drivers/usb/phy/phy-samsung-usb.c  |   26 +++++++
 drivers/usb/phy/phy-samsung-usb.h  |    1 +
 drivers/usb/phy/phy-samsung-usb2.c |    5 ++
 drivers/usb/phy/phy-samsung-usb3.c |  119 +++++++++++++++++++++++++++++--
 include/linux/usb/phy.h            |  141 ++++++++++++++++++++++++++++++++++++
 8 files changed, 358 insertions(+), 11 deletions(-)

-- 
1.7.6.5

