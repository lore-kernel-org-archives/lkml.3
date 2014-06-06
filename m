Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaFFMMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:12:35 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57524 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaFFMMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:12:33 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, kishon@ti.com, mathias.nyman@intel.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, jwerner@chromium.org,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v1 0/4] Fine tune USB 3.0 PHY on exynos5420
Date: Fri,  6 Jun 2014 17:42:11 +0530
Message-Id: <1402056736-12674-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RFC version of this series was posted long time back, around December
last year [1].
This series is based on Heikki's patches for simpliefied phy lookup table:
[PATCHv2 0/6] phy: simplified phy lookup [2], applied against 'usb-next'
branch of Greg's usb tree.
Tested on peach-pit boards with SuperSpeed devices and confirmed that now
the devices are detected as SupedSpeed, not as HighSpeed.

Explanation for the need of this patch-series:
"The DWC3-exynos eXtensible host controller present on Exynos5420
SoC is quirky. The PHY serving this controller operates at High-Speed
by default, so it detects even Super-speed devices as high-speed ones.
Certain PHY parameters like Tx LOS levels and Boost levels need to be
calibrated further post initialization of xHCI controller, to get
SuperSpeed operations working."

[1] https://lkml.org/lkml/2013/12/10/365
[2] https://lkml.org/lkml/2014/6/5/358

Vivek Gautam (4):
  phy: Add provision for calibrating phy.
  usb: host: xhci-plat: Add support to get PHYs
  usb: host: xhci-plat: Caibrate PHY post host reset
  phy: exynos5-usbdrd: Calibrate LOS levels for exynos5420/5800

 drivers/phy/phy-core.c           |   36 ++++++++
 drivers/phy/phy-exynos5-usbdrd.c |  168 ++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/xhci-plat.c     |   74 ++++++++++++++++-
 drivers/usb/host/xhci.h          |    3 +
 include/linux/phy/phy.h          |    7 ++
 5 files changed, 286 insertions(+), 2 deletions(-)

-- 
1.7.10.4

