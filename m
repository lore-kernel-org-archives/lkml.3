Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbbAKSJp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 13:09:45 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:39270 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbbAKSJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 13:09:41 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Samuel Pitoiset <samuel.pitoiset@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm: nouveau: core: engine: perfmon: base: Remove unused function
Date: Sun, 11 Jan 2015 19:12:45 +0100
Message-Id: <1420999965-22216-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function nouveau_perfsig_wrap() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/nouveau/core/engine/perfmon/base.c |   20 --------------------
 drivers/gpu/drm/nouveau/core/engine/perfmon/priv.h |    5 -----
 2 files changed, 25 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/perfmon/base.c b/drivers/gpu/drm/nouveau/core/engine/perfmon/base.c
index 6301381..d0c5255 100644
--- a/drivers/gpu/drm/nouveau/core/engine/perfmon/base.c
+++ b/drivers/gpu/drm/nouveau/core/engine/perfmon/base.c
@@ -80,26 +80,6 @@ nouveau_perfsig_find(struct nouveau_perfmon *ppm, const char *name, u32 size,
 	return nouveau_perfsig_find_(dom, name, size);
 }
 
-struct nouveau_perfctr *
-nouveau_perfsig_wrap(struct nouveau_perfmon *ppm, const char *name,
-		     struct nouveau_perfdom **pdom)
-{
-	struct nouveau_perfsig *sig;
-	struct nouveau_perfctr *ctr;
-
-	sig = nouveau_perfsig_find(ppm, name, strlen(name), pdom);
-	if (!sig)
-		return NULL;
-
-	ctr = kzalloc(sizeof(*ctr), GFP_KERNEL);
-	if (ctr) {
-		ctr->signal[0] = sig;
-		ctr->logic_op = 0xaaaa;
-	}
-
-	return ctr;
-}
-
 /*******************************************************************************
  * Perfmon object classes
  ******************************************************************************/
diff --git a/drivers/gpu/drm/nouveau/core/engine/perfmon/priv.h b/drivers/gpu/drm/nouveau/core/engine/perfmon/priv.h
index 0ac8714..1a0989e 100644
--- a/drivers/gpu/drm/nouveau/core/engine/perfmon/priv.h
+++ b/drivers/gpu/drm/nouveau/core/engine/perfmon/priv.h
@@ -30,11 +30,6 @@ struct nouveau_perfsig {
 	const char *name;
 };
 
-struct nouveau_perfdom;
-struct nouveau_perfctr *
-nouveau_perfsig_wrap(struct nouveau_perfmon *, const char *,
-		     struct nouveau_perfdom **);
-
 struct nouveau_specdom {
 	u16 signal_nr;
 	const struct nouveau_specsig *signal;
-- 
1.7.10.4

