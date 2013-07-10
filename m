Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab3GJLQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:16:49 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:35205 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3GJLQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:16:44 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/3] drm/edid: Fix uninitialized return variable in edid_load()
Date: Wed, 10 Jul 2013 13:16:35 +0200
Message-Id: <1373454996-21706-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373454996-21706-1-git-send-email-geert@linux-m68k.org>
References: <1373454996-21706-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gpu/drm/drm_edid_load.c: In function ‘edid_load’:
drivers/gpu/drm/drm_edid_load.c:141: warning: ‘edid’ may be used uninitialized
in this function

In some error cases, edid_load() will return the uninitialized variable.
Initialize it to NULL to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/gpu/drm/drm_edid_load.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_edid_load.c b/drivers/gpu/drm/drm_edid_load.c
index 2c2803f..9be3467 100644
--- a/drivers/gpu/drm/drm_edid_load.c
+++ b/drivers/gpu/drm/drm_edid_load.c
@@ -138,7 +138,7 @@ static u8 *edid_load(struct drm_connector *connector, char *name,
 {
 	const struct firmware *fw;
 	struct platform_device *pdev;
-	u8 *fwdata = NULL, *edid, *new_edid;
+	u8 *fwdata = NULL, *edid = NULL, *new_edid;
 	int fwsize, expected;
 	int builtin = 0, err = 0;
 	int i, valid_extensions = 0;
-- 
1.7.9.5

