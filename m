Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab3GJLQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:16:47 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:35207 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3GJLQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:16:44 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/3] drm/edid: Make edid_load() return a void *
Date: Wed, 10 Jul 2013 13:16:36 +0200
Message-Id: <1373454996-21706-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373454996-21706-1-git-send-email-geert@linux-m68k.org>
References: <1373454996-21706-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always use "void *" for arbitrary memory buffers, as this allows to drop
casts in assignments.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/gpu/drm/drm_edid_load.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid_load.c b/drivers/gpu/drm/drm_edid_load.c
index 9be3467..d1daf34 100644
--- a/drivers/gpu/drm/drm_edid_load.c
+++ b/drivers/gpu/drm/drm_edid_load.c
@@ -133,7 +133,7 @@ static u8 generic_edid[GENERIC_EDIDS][128] = {
 	},
 };
 
-static u8 *edid_load(struct drm_connector *connector, char *name,
+static void *edid_load(struct drm_connector *connector, char *name,
 			const char *connector_name)
 {
 	const struct firmware *fw;
@@ -263,7 +263,7 @@ int drm_load_edid_firmware(struct drm_connector *connector)
 	if (*last == '\n')
 		*last = '\0';
 
-	edid = (struct edid *) edid_load(connector, edidname, connector_name);
+	edid = edid_load(connector, edidname, connector_name);
 	if (IS_ERR_OR_NULL(edid))
 		return 0;
 
-- 
1.7.9.5

