Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab3HFSIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:08:54 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7447 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab3HFSIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:08:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 06 Aug 2013 11:08:51 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v2 0/6] USB tree changes for Tegra30 and Tegra114 USB Host support
Date: Tue, 6 Aug 2013 21:08:32 +0300
Message-ID: <1375812518-3847-1-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here are the patches for the USB tree to enable USB Host support on Tegra30 and
Tegra114. These are based on my and Mikko's cleanup patches that just got
merged to Felipe's tree.

The first one touches the core hub code to prevent certain (non-standard) clock
disable features as our controller doesn't support those.
The rest are changes to our PHY and EHCI drivers to deal with a few changed
register addresses and a few additional PHY parameters that need to be set
for proper signal quality.

v2 diff:
Patch 1: Added Alan's ack
Patch 2 & 5: Change register bitmasks to not contain shifted-out bits
Changed the order of patches 4 & 5
Patch 5: Don't touch new PHY params under T20

Tuomas Tynkkynen (6):
  usb: host: add has_tdi_phy_lpm capability bit
  usb: phy: tegra: Fix wrong PHY parameters
  usb: phy: tegra: Tegra30 support
  Documentation: New DT parameters for tegra30-usb-phy
  usb: phy: tegra: Program new PHY parameters
  usb: host: tegra: Tegra30 support

 .../bindings/usb/nvidia,tegra20-usb-phy.txt        |  15 +-
 drivers/usb/chipidea/host.c                        |   1 +
 drivers/usb/host/ehci-hub.c                        |  14 +-
 drivers/usb/host/ehci-tegra.c                      |  34 +++-
 drivers/usb/host/ehci.h                            |   1 +
 drivers/usb/phy/phy-tegra-usb.c                    | 220 ++++++++++++++++-----
 include/linux/usb/tegra_usb_phy.h                  |  23 +++
 7 files changed, 242 insertions(+), 66 deletions(-)

-- 
1.8.1.5

