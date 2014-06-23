Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaFWNDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:03:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36701 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbaFWNDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:03:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 11/93] drm/gf119-/disp: fix nasty bug which can clobber SOR0's clock setup
Date: Mon, 23 Jun 2014 14:01:50 +0100
Message-Id: <1403528592-2163-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 0f1d360b2ee3a2a0f510d3f1bcd3f5ebe5d41265 upstream.

Fixes a LVDS bleed issue on Lenovo W530 that can occur under a
number of circumstances.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c b/drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c
index 52dd7a1db729..8f336558c681 100644
--- a/drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c
@@ -678,7 +678,7 @@ exec_clkcmp(struct nv50_disp_priv *priv, int head, int id,
 	}
 
 	if (outp == 8)
-		return false;
+		return conf;
 
 	data = exec_lookup(priv, head, outp, ctrl, dcb, &ver, &hdr, &cnt, &len, &info1);
 	if (data == 0x0000)
-- 
1.9.1

