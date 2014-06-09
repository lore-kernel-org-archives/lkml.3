Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935602AbaFIXOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:14:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274AbaFIWpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.14 11/78] drm/gf119-/disp: fix nasty bug which can clobber SOR0s clock setup
Date: Mon,  9 Jun 2014 15:47:51 -0700
Message-Id: <20140609224813.722195395@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 0f1d360b2ee3a2a0f510d3f1bcd3f5ebe5d41265 upstream.

Fixes a LVDS bleed issue on Lenovo W530 that can occur under a
number of circumstances.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c
@@ -732,7 +732,7 @@ exec_clkcmp(struct nv50_disp_priv *priv,
 	}
 
 	if (outp == 8)
-		return false;
+		return conf;
 
 	data = exec_lookup(priv, head, outp, ctrl, dcb, &ver, &hdr, &cnt, &len, &info1);
 	if (data == 0x0000)


