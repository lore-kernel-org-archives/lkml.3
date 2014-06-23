Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaFWIcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:32:36 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55450 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 024/111] drm/gf119-/disp: fix nasty bug which can clobber SOR0's clock setup
Date: Mon, 23 Jun 2014 10:30:59 +0200
Message-Id: <afb44e1758741b45be382544527b6edf99fd2f6f.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0f1d360b2ee3a2a0f510d3f1bcd3f5ebe5d41265 upstream.

Fixes a LVDS bleed issue on Lenovo W530 that can occur under a
number of circumstances.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0

