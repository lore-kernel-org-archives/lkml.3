Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbaIOWNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:13:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50693 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbaIOWM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:12:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Warren <swarren@nvidia.com>, Thierry Reding <treding@nvidia.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 140/187] drm/tegra: add MODULE_DEVICE_TABLEs
Date: Mon, 15 Sep 2014 15:09:10 -0700
Message-Id: <1410818997-9432-141-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit ef70728c7a6571a1a7115031e932b811f1740b2e upstream.

When tegra-drm.ko is built as a module, these MODULE_DEVICE_TABLEs allow
the module to be auto-loaded since the module will match the devices
instantiated from device tree.

(Notes for stable: in 3.14+, just git rm any conflicting file, since they
are added in later kernels. For 3.13 and below, manual merging will be
needed)

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
[ kamal: backport to 3.13: context; skip modules added later ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/tegra/dc.c   | 1 +
 drivers/gpu/drm/tegra/gr2d.c | 1 +
 drivers/gpu/drm/tegra/gr3d.c | 1 +
 drivers/gpu/drm/tegra/hdmi.c | 1 +
 4 files changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index ae1cb31..614e8ef 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1252,6 +1252,7 @@ static struct of_device_id tegra_dc_of_match[] = {
 	{ .compatible = "nvidia,tegra20-dc", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, tegra_dc_of_match);
 
 struct platform_driver tegra_dc_driver = {
 	.driver = {
diff --git a/drivers/gpu/drm/tegra/gr2d.c b/drivers/gpu/drm/tegra/gr2d.c
index 7ec4259..684ad13 100644
--- a/drivers/gpu/drm/tegra/gr2d.c
+++ b/drivers/gpu/drm/tegra/gr2d.c
@@ -129,6 +129,7 @@ static const struct of_device_id gr2d_match[] = {
 	{ .compatible = "nvidia,tegra20-gr2d" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, gr2d_match);
 
 static const u32 gr2d_addr_regs[] = {
 	GR2D_UA_BASE_ADDR,
diff --git a/drivers/gpu/drm/tegra/gr3d.c b/drivers/gpu/drm/tegra/gr3d.c
index 4cec8f5..b8503b2 100644
--- a/drivers/gpu/drm/tegra/gr3d.c
+++ b/drivers/gpu/drm/tegra/gr3d.c
@@ -127,6 +127,7 @@ static const struct of_device_id tegra_gr3d_match[] = {
 	{ .compatible = "nvidia,tegra20-gr3d" },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, tegra_gr3d_match);
 
 static const u32 gr3d_addr_regs[] = {
 	GR3D_IDX_ATTRIBUTE( 0),
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index 0cd9bc2..a2eb3c0 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -1309,6 +1309,7 @@ static const struct of_device_id tegra_hdmi_of_match[] = {
 	{ .compatible = "nvidia,tegra20-hdmi", .data = &tegra20_hdmi_config },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, tegra_hdmi_of_match);
 
 static int tegra_hdmi_probe(struct platform_device *pdev)
 {
-- 
1.9.1

