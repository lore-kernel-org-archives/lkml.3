Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbaKRNsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:48:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:58362 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754037AbaKRNqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:46:25 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 2/3] drm: panel: simple-panel: add support for bus_format retrieval
Date: Tue, 18 Nov 2014 14:46:19 +0100
Message-Id: <1416318380-20122-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416318380-20122-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1416318380-20122-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a way to specify panel requirement in terms of supported media bus
format (particularly useful for panels connected to an RGB or LVDS bus).

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/gpu/drm/panel/panel-simple.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 23de22f..66838a5 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -61,6 +61,8 @@ struct panel_desc {
 		unsigned int disable;
 		unsigned int unprepare;
 	} delay;
+
+	u32 bus_format;
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

