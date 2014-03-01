Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052AbaCAFEh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 00:04:37 -0500
Received: from gnurou.org ([207.192.72.5]:45664 "EHLO mail.gnurou.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750752AbaCAFEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 00:04:13 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: David Airlie <airlied@linux.ie>, Thierry Reding <treding@nvidia.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/2] drm/panel: remove redundant regulator_disable()
Date: Sat,  1 Mar 2014 14:00:59 +0900
Message-Id: <1393650059-5152-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393650059-5152-1-git-send-email-acourbot@nvidia.com>
References: <1393650059-5152-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator_disable() is already performed by panel_simple_disable(),
which is called by panel_simple_remove().

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/panel/panel-simple.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index d1cabfa..35d1518 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -257,8 +257,6 @@ static int panel_simple_remove(struct device *dev)
 	if (panel->backlight)
 		put_device(&panel->backlight->dev);
 
-	regulator_disable(panel->supply);
-
 	return 0;
 }
 
-- 
1.9.0

