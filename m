Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab3EVTtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:49:41 -0400
Received: from mout.gmx.net ([212.227.17.20]:65460 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757029Ab3EVTt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:49:27 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX1888osGqFk8fhsiCpAE12q5nxbRymWVb2v+O6pe6D
	Pmla7LAqXrc4OL
From: Marc Dietrich <marvin24@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 2/2] nouveau: replace large udelay by mdelay
Date: Wed, 22 May 2013 21:48:42 +0200
Message-Id: <d75e9ee62d4cba8efc86c23476f746f145ecb676.1369251478.git.marvin24@gmx.de>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1369251478.git.marvin24@gmx.de>
References: <cover.1369251478.git.marvin24@gmx.de>
In-Reply-To: <cover.1369251478.git.marvin24@gmx.de>
References: <cover.1369251478.git.marvin24@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM has a maximum of 2000 usec delay. Use mdelay for larger delays.
This affects distro kernels mostly.

Cc: David Airlie <airlied@linux.ie>
Cc: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Marc Dietrich <marvin24@gmx.de>
---
 drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c b/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
index d0817d9..ed7415e 100644
--- a/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
@@ -51,7 +51,8 @@ nv50_dac_sense(struct nv50_disp_priv *priv, int or, u32 loadval)
 	const u32 doff = (or * 0x800);
 	int load = -EINVAL;
 	nv_wr32(priv, 0x61a00c + doff, 0x00100000 | loadval);
-	udelay(9500);
+	mdelay(9);
+	udelay(500);
 	nv_wr32(priv, 0x61a00c + doff, 0x80000000);
 	load = (nv_rd32(priv, 0x61a00c + doff) & 0x38000000) >> 27;
 	nv_wr32(priv, 0x61a00c + doff, 0x00000000);
-- 
1.7.9.5
