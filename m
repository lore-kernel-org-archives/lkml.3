Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaD1JY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:24:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42600 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbaD1JYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:24:52 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        k.debski@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v3 0/4] usb: ehci/ohci-exynos: Move to generic phy framework
Date: Mon, 28 Apr 2014 14:54:36 +0530
Message-Id: <1398677080-30555-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based and tested on 'usb-next' branch of Greg's usb tree, with relevant
device tree patches[1]

Changes from v2:
 - Added two patches in the series for some cleanup.
   usb: ohci-exynos: Use struct device instead of platform_device
   usb: ehci-exynos: Use struct device instead of platform_device
 - Addressed review comments.
   -- Moved exynos_ohci_phyg_on()/off routines inside
      exynos_ohci_phy_enable()/disable.
   -- Added functions exynos_ehci_phy_enable() and exynos_ehci_phy_disable()
      and moved exynos_ehci_phyg_on()/off routines respectively in them.
   -- Added necessary checks.

Kamil Debski (1):
  usb: ehci-exynos: Change to use phy provided by the generic phy
    framework

Vivek Gautam (3):
  usb: ohci-exynos: Use struct device instead of platform_device
  usb: ehci-exynos: Use struct device instead of platform_device
  usb: ohci-exynos: Add facility to use phy provided by the generic phy
    framework

 .../devicetree/bindings/usb/exynos-usb.txt         |   37 +++++
 drivers/usb/host/ehci-exynos.c                     |  148 +++++++++++++++++---
 drivers/usb/host/ohci-exynos.c                     |  141 ++++++++++++++++---
 3 files changed, 280 insertions(+), 46 deletions(-)

-- 
1.7.10.4

