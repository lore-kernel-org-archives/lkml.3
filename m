Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab3CKTq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:46:57 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:48680 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab3CKTqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:46:55 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: Alan Cox <alan@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: gpu: drm: gma500: Replaced calls kzalloc & memcpy with kmemdup
Date: Mon, 11 Mar 2013 21:46:14 +0200
Message-Id: <1363031174-22525-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced calls kzalloc followed by memcpy with call to kmemdup.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/gpu/drm/gma500/intel_bios.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/gma500/intel_bios.c b/drivers/gpu/drm/gma500/intel_bios.c
index 403fffb..d349734 100644
--- a/drivers/gpu/drm/gma500/intel_bios.c
+++ b/drivers/gpu/drm/gma500/intel_bios.c
@@ -218,12 +218,11 @@ static void parse_backlight_data(struct drm_psb_private *dev_priv,
 	bl_start = find_section(bdb, BDB_LVDS_BACKLIGHT);
 	vbt_lvds_bl = (struct bdb_lvds_backlight *)(bl_start + 1) + p_type;
 
-	lvds_bl = kzalloc(sizeof(*vbt_lvds_bl), GFP_KERNEL);
+	lvds_bl = kmemdup(vbt_lvds_bl, sizeof(*vbt_lvds_bl), GFP_KERNEL);
 	if (!lvds_bl) {
 		dev_err(dev_priv->dev->dev, "out of memory for backlight data\n");
 		return;
 	}
-	memcpy(lvds_bl, vbt_lvds_bl, sizeof(*vbt_lvds_bl));
 	dev_priv->lvds_bl = lvds_bl;
 }
 
-- 
1.7.9.5

