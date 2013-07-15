Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab3GOTyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:54:03 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16206 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab3GOTyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:54:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 15 Jul 2013 12:53:12 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v2 0/9] Tegra USB cleanup series
Date: Mon, 15 Jul 2013 22:53:40 +0300
Message-ID: <1373918029-28977-1-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's a V2 of the few cleanup patches for the Tegra USB drivers, to be applied
on top of Mikko's two patch sets. It mostly deals with removing all usage of
platform data and using standard helpers and enums instead of Tegra-specific
ones.

V2 Diff:
Patch 5: Do the usb_add_phy_dev as the very last thing in .probe
Patch 9: Default to host mode if the property didn't exist

Tuomas Tynkkynen (9):
  usb: phy: tegra: Remove unnecessary 'dev' field
  usb: host: tegra: Remove leftover code
  usb: tegra: host: Remove references to plat data
  ARM: tegra: Remove USB platform data
  usb: phy: tegra: Register as an USB PHY.
  usb: host: tegra: Locate a PHY via standard API
  usb: phy: tegra: Remove custom PHY locating APIs
  usb: phy: tegra: Use DT helpers for phy_type
  usb: phy: tegra: Use DT helpers for dr_mode

 arch/arm/mach-tegra/tegra.c             |  38 +-----------
 drivers/usb/host/ehci-tegra.c           |  37 ++----------
 drivers/usb/phy/phy-tegra-usb.c         | 102 ++++++++++++++++----------------
 include/linux/platform_data/tegra_usb.h |  32 ----------
 include/linux/usb/tegra_usb_phy.h       |  16 +----
 5 files changed, 59 insertions(+), 166 deletions(-)
 delete mode 100644 include/linux/platform_data/tegra_usb.h

-- 
1.8.1.5

