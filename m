Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab3KSLPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 06:15:12 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:50831 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab3KSLPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 06:15:09 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH RESEND] drm/edid: Make edid_load() return a void *
Date: Tue, 19 Nov 2013 12:15:05 +0100
Message-Id: <1384859705-27733-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always use "void *" for arbitrary memory buffers, as this allows to drop
casts in assignments.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
---
 drivers/gpu/drm/drm_edid_load.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid_load.c b/drivers/gpu/drm/drm_edid_load.c
index 9081172ef057..1b4c7a5442c5 100644
--- a/drivers/gpu/drm/drm_edid_load.c
+++ b/drivers/gpu/drm/drm_edid_load.c
@@ -141,7 +141,7 @@ static int edid_size(const u8 *edid, int data_size)
 	return (edid[0x7e] + 1) * EDID_LENGTH;
 }
 
-static u8 *edid_load(struct drm_connector *connector, const char *name,
+static void *edid_load(struct drm_connector *connector, const char *name,
 			const char *connector_name)
 {
 	const struct firmware *fw = NULL;
@@ -263,7 +263,7 @@ int drm_load_edid_firmware(struct drm_connector *connector)
 	if (*last == '\n')
 		*last = '\0';
 
-	edid = (struct edid *) edid_load(connector, edidname, connector_name);
+	edid = edid_load(connector, edidname, connector_name);
 	if (IS_ERR_OR_NULL(edid))
 		return 0;
 
-- 
1.7.9.5

