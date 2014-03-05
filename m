Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbaCEPTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:19:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40922 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956AbaCEOZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilia Mirkin <imirkin@alum.mit.edu>, Ben Skeggs <bskeggs@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 045/131] drm/nv50/disp: use correct register to determine DP display bpp
Date: Wed,  5 Mar 2014 14:22:49 +0000
Message-Id: <1394029455-23128-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Mirkin <imirkin@alum.mit.edu>

commit a7f1c1e65b68e1e1ab70898528d5977ed68a0a7d upstream.

Commit 0a0afd282f ("drm/nv50-/disp: move DP link training to core and
train from supervisor") added code that uses the wrong register for
computing the display bpp, used for bandwidth calculation. Adjust to use
the same register as used by exec_clkcmp and nv50_disp_intr_unk20_2_dp.

Reported-by: Torsten Wagner <torsten.wagner@gmail.com>
Reported-by: Michael Gulick <mgulick@mathworks.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=67628
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/disp/nv50.c b/drivers/gpu/drm/nouveau/core/engine/disp/nv50.c
index 7ffe2f3..bcebe96 100644
--- a/drivers/gpu/drm/nouveau/core/engine/disp/nv50.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/nv50.c
@@ -1112,7 +1112,7 @@ nv50_disp_intr_unk20_2(struct nv50_disp_priv *priv, int head)
 	if (conf != ~0) {
 		if (outp.location == 0 && outp.type == DCB_OUTPUT_DP) {
 			u32 soff = (ffs(outp.or) - 1) * 0x08;
-			u32 ctrl = nv_rd32(priv, 0x610798 + soff);
+			u32 ctrl = nv_rd32(priv, 0x610794 + soff);
 			u32 datarate;
 
 			switch ((ctrl & 0x000f0000) >> 16) {
-- 
1.9.0

