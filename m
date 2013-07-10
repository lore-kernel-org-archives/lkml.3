Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab3GJLQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:16:50 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:35206 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab3GJLQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:16:44 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/3] drm/edid: Fix constness warning in drm_load_edid_firmware()
Date: Wed, 10 Jul 2013 13:16:34 +0200
Message-Id: <1373454996-21706-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gpu/drm/drm_edid_load.c: In function ‘drm_load_edid_firmware’:
drivers/gpu/drm/drm_edid_load.c:245: warning: initialization discards qualifiers from pointer target type

drm_get_connector_name() returns a "const char *", hence propagate the
const where needed.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/gpu/drm/drm_edid_load.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid_load.c b/drivers/gpu/drm/drm_edid_load.c
index a4f5ce1..2c2803f 100644
--- a/drivers/gpu/drm/drm_edid_load.c
+++ b/drivers/gpu/drm/drm_edid_load.c
@@ -134,7 +134,7 @@ static u8 generic_edid[GENERIC_EDIDS][128] = {
 };
 
 static u8 *edid_load(struct drm_connector *connector, char *name,
-			char *connector_name)
+			const char *connector_name)
 {
 	const struct firmware *fw;
 	struct platform_device *pdev;
@@ -242,7 +242,7 @@ out:
 
 int drm_load_edid_firmware(struct drm_connector *connector)
 {
-	char *connector_name = drm_get_connector_name(connector);
+	const char *connector_name = drm_get_connector_name(connector);
 	char *edidname = edid_firmware, *last, *colon;
 	int ret;
 	struct edid *edid;
-- 
1.7.9.5

