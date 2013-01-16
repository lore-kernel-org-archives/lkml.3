Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab3APNaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:30:19 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8156 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab3APNaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:30:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 16 Jan 2013 05:29:04 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <linux-doc@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH 0/4] usb: Supporting patches for registering Tegra USB PHY as a platform driver
Date: Wed, 16 Jan 2013 19:00:18 +0530
Message-ID: <1358343022-28919-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of registering tegra USB PHY as platform driver, prepared
patches to add separate DT nodes describing Tegra USB PHY properties.
Modified instance number based processing to make use of the added
DT properties. As PHY will be registered as separate driver, removed
ehci register access from PHY driver and added APIs to ehci driver for
this purpose.

Venu Byravarasu (4):
  arm: tegra: Add DT nodes for Tegra USB PHY
  USB: PHY: Get rid of instance number to differentiate legacy
    controller
  USB: PHY: Tegra: Get rid of instance number to differentiate PHY type
  usb: Add APIs to access host registers from Tegra PHY

 .../bindings/usb/nvidia,tegra20-ehci.txt           |    1 +
 .../bindings/usb/nvidia,tegra20-usb-phy.txt        |   14 +++
 arch/arm/boot/dts/tegra20.dtsi                     |   22 +++++
 drivers/usb/host/ehci-tegra.c                      |   71 ++++++++++++++-
 drivers/usb/phy/tegra_usb_phy.c                    |  100 +++++++-------------
 include/linux/usb/tegra_usb_phy.h                  |    8 ++
 6 files changed, 149 insertions(+), 67 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt

