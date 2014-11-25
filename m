Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbaKYLun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:50:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58229 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaKYKk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>, Sven Joachim <svenjoac@gmx.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 053/254] drm/nouveau/ltc: fix tag base address getting truncated if above 4GiB
Date: Tue, 25 Nov 2014 10:36:43 +0000
Message-Id: <1416912004-5928-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 147ed897e807e1a6e2c6fd9dc91830f1d2831d43 upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Sven Joachim <svenjoac@gmx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/core/subdev/ltcg/gf100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/ltcg/gf100.c b/drivers/gpu/drm/nouveau/core/subdev/ltcg/gf100.c
index f2f3338a967a..effe88888bf9 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/ltcg/gf100.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/ltcg/gf100.c
@@ -135,7 +135,7 @@ gf100_ltcg_init_tag_ram(struct nouveau_fb *pfb, struct gf100_ltcg_priv *priv)
 	if (ret) {
 		priv->num_tags = 0;
 	} else {
-		u64 tag_base = (priv->tag_ram->offset << 12) + tag_margin;
+		u64 tag_base = ((u64)priv->tag_ram->offset << 12) + tag_margin;
 
 		tag_base += tag_align - 1;
 		ret = do_div(tag_base, tag_align);
-- 
2.1.0

