Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965092Ab3GQXKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:10:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56690 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964892Ab3GQWz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilia Mirkin <imirkin@alum.mit.edu>, Ben Skeggs <bskeggs@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 121/145] drm/nva3/disp: Fix HDMI audio regression
Date: Wed, 17 Jul 2013 15:47:33 -0700
Message-Id: <1374101277-7915-122-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Mirkin <imirkin@alum.mit.edu>

commit bf03d1b293cc556df53545e318110505014d805e upstream.

This is the nva3 counterpart to commit beba44b17 (drm/nv84/disp: Fix
HDMI audio regression). The regression happened as a result of
refactoring in commit 8e9e3d2de (drm/nv84/disp: move hdmi control into
core).

Reported-and-tested-by: Max Baldwin <archerseven@gmail.com>
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/nouveau/core/engine/disp/hdminva3.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/core/engine/disp/hdminva3.c b/drivers/gpu/drm/nouveau/core/engine/disp/hdminva3.c
index f065fc2..db8c6fd 100644
--- a/drivers/gpu/drm/nouveau/core/engine/disp/hdminva3.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/hdminva3.c
@@ -55,6 +55,10 @@ nva3_hdmi_ctrl(struct nv50_disp_priv *priv, int head, int or, u32 data)
 	nv_wr32(priv, 0x61c510 + soff, 0x00000000);
 	nv_mask(priv, 0x61c500 + soff, 0x00000001, 0x00000001);
 
+	nv_mask(priv, 0x61c5d0 + soff, 0x00070001, 0x00010001); /* SPARE, HW_CTS */
+	nv_mask(priv, 0x61c568 + soff, 0x00010101, 0x00000000); /* ACR_CTRL, ?? */
+	nv_mask(priv, 0x61c578 + soff, 0x80000000, 0x80000000); /* ACR_0441_ENABLE */
+
 	/* ??? */
 	nv_mask(priv, 0x61733c, 0x00100000, 0x00100000); /* RESETF */
 	nv_mask(priv, 0x61733c, 0x10000000, 0x10000000); /* LOOKUP_EN */
-- 
1.8.1.2

