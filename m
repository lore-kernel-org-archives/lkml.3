Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab3K0CAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:00:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab3K0A5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Ilia Mirkin <imirkin@alum.mit.edu>
Subject: [PATCH 3.10 13/80] drm/nv50-/disp: remove dcb_outp_match call, and related variables
Date: Tue, 26 Nov 2013 16:56:42 -0800
Message-Id: <20131127005641.866263356@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Velikov <emil.l.velikov@gmail.com>

commit 9a7046d55f319b2dde5d2536cc2adb01ebdbe09e upstream.

Unused and irrelavant since the code move of DP training/linkcontrol interrupt

Signed-off-by: Emil Velikov <emil.l.velikov@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/engine/disp/sornv50.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/gpu/drm/nouveau/core/engine/disp/sornv50.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/sornv50.c
@@ -47,14 +47,8 @@ int
 nv50_sor_mthd(struct nouveau_object *object, u32 mthd, void *args, u32 size)
 {
 	struct nv50_disp_priv *priv = (void *)object->engine;
-	struct nouveau_bios *bios = nouveau_bios(priv);
-	const u16 type = (mthd & NV50_DISP_SOR_MTHD_TYPE) >> 12;
 	const u8  head = (mthd & NV50_DISP_SOR_MTHD_HEAD) >> 3;
-	const u8  link = (mthd & NV50_DISP_SOR_MTHD_LINK) >> 2;
 	const u8    or = (mthd & NV50_DISP_SOR_MTHD_OR);
-	const u16 mask = (0x0100 << head) | (0x0040 << link) | (0x0001 << or);
-	struct dcb_output outp;
-	u8  ver, hdr;
 	u32 data;
 	int ret = -EINVAL;
 
@@ -62,8 +56,6 @@ nv50_sor_mthd(struct nouveau_object *obj
 		return -EINVAL;
 	data = *(u32 *)args;
 
-	if (type && !dcb_outp_match(bios, type, mask, &ver, &hdr, &outp))
-		return -ENODEV;
 
 	switch (mthd & ~0x3f) {
 	case NV50_DISP_SOR_PWR:


