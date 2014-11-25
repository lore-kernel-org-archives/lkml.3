Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaKYKlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:41:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58239 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbaKYKk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>, Sven Joachim <svenjoac@gmx.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 055/254] drm/nv50/disp: fix dpms regression on certain boards
Date: Tue, 25 Nov 2014 10:36:45 +0000
Message-Id: <1416912004-5928-56-git-send-email-luis.henriques@canonical.com>
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

commit 5838ae610ff36777b8fce6f353c2417980c1a1fa upstream.

Reported in fdo#82527 comment #2.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Sven Joachim <svenjoac@gmx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/disp/nv50.c b/drivers/gpu/drm/nouveau/core/engine/disp/nv50.c
index 2283c442a10d..90b0eb1d042b 100644
--- a/drivers/gpu/drm/nouveau/core/engine/disp/nv50.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/nv50.c
@@ -1570,9 +1570,10 @@ nv50_disp_intr_unk40_0_tmds(struct nv50_disp_priv *priv, struct dcb_output *outp
 	const int   or = ffs(outp->or) - 1;
 	const u32 loff = (or * 0x800) + (link * 0x80);
 	const u16 mask = (outp->sorconf.link << 6) | outp->or;
+	struct dcb_output match;
 	u8  ver, hdr;
 
-	if (dcb_outp_match(bios, DCB_OUTPUT_DP, mask, &ver, &hdr, outp))
+	if (dcb_outp_match(bios, DCB_OUTPUT_DP, mask, &ver, &hdr, &match))
 		nv_mask(priv, 0x61c10c + loff, 0x00000001, 0x00000000);
 }
 
-- 
2.1.0

