Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaGVMZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:25:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:32948 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754184AbaGVMXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:23:54 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 4/5] drm: panel: simple-panel: add support for bus_format retrieval
Date: Tue, 22 Jul 2014 14:23:46 +0200
Message-Id: <1406031827-12432-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a way to specify panel requirement in terms of supported media bus
format (particularly useful for panels connected to an RGB or LVDS bus).

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/gpu/drm/panel/panel-simple.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 3f76944..42fd6d1 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -41,6 +41,8 @@ struct panel_desc {
 		unsigned int width;
 		unsigned int height;
 	} size;
+
+	enum video_bus_format bus_format;
 };
 
 struct panel_simple {
@@ -89,6 +91,9 @@ static int panel_simple_get_fixed_modes(struct panel_simple *panel)
 
 	connector->display_info.width_mm = panel->desc->size.width;
 	connector->display_info.height_mm = panel->desc->size.height;
+	if (panel->desc->bus_format)
+		drm_display_info_set_bus_formats(&connector->display_info,
+						 &panel->desc->bus_format, 1);
 
 	return num;
 }
-- 
1.8.3.2

