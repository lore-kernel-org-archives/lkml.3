Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbbA0MQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:16:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34812 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758106AbbA0MQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:16:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilia Mirkin <imirkin@alum.mit.edu>, Ben Skeggs <bskeggs@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 004/126] drm/nv4c/mc: disable msi
Date: Tue, 27 Jan 2015 12:15:09 +0000
Message-Id: <1422361031-19364-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Mirkin <imirkin@alum.mit.edu>

commit 4761703bd04bbdf56396d264903cc5a1fdcb3c01 upstream.

Several users have, over time, reported issues with MSI on these IGPs.
They're old, rarely available, and MSI doesn't provide such huge
advantages on them. Just disable.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=87361
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=74492
Fixes: fa8c9ac72fe ("drm/nv4c/mc: nv4x igp's have a different msi rearm register")
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/core/subdev/mc/nv4c.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/mc/nv4c.c b/drivers/gpu/drm/nouveau/core/subdev/mc/nv4c.c
index a75c35ccf25c..165401c4045c 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/mc/nv4c.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/mc/nv4c.c
@@ -24,13 +24,6 @@
 
 #include "nv04.h"
 
-static void
-nv4c_mc_msi_rearm(struct nouveau_mc *pmc)
-{
-	struct nv04_mc_priv *priv = (void *)pmc;
-	nv_wr08(priv, 0x088050, 0xff);
-}
-
 struct nouveau_oclass *
 nv4c_mc_oclass = &(struct nouveau_mc_oclass) {
 	.base.handle = NV_SUBDEV(MC, 0x4c),
@@ -41,5 +34,4 @@ nv4c_mc_oclass = &(struct nouveau_mc_oclass) {
 		.fini = _nouveau_mc_fini,
 	},
 	.intr = nv04_mc_intr,
-	.msi_rearm = nv4c_mc_msi_rearm,
 }.base;
-- 
2.1.4

