Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbaI2OEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:04:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47356 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754487AbaI2OEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:04:00 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 4/5] drm: panel: simple-panel: add support for bus_format retrieval
Date: Mon, 29 Sep 2014 16:02:42 +0200
Message-Id: <1411999363-28770-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411999363-28770-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1411999363-28770-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

Provide a way to specify panel requirement in terms of supported media bus
format (particularly useful for panels connected to an RGB or LVDS bus).

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/gpu/drm/panel/panel-simple.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 4ce1db0..eb3a17e 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -61,6 +61,8 @@ struct panel_desc {
 		unsigned int disable;
 		unsigned int unprepare;
 	} delay;
+
+	enum video_bus_format bus_format;
 };
 
 struct panel_simple {
@@ -111,6 +113,9 @@ static int panel_simple_get_fixed_modes(struct panel_simple *panel)
 	connector->display_info.bpc = panel->desc->bpc;
 	connector->display_info.width_mm = panel->desc->size.width;
 	connector->display_info.height_mm = panel->desc->size.height;
+	if (panel->desc->bus_format)
+		drm_display_info_set_bus_formats(&connector->display_info,
+						 &panel->desc->bus_format, 1);
 
 	return num;
 }
-- 
1.9.1

