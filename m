Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbbAYS4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:56:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbbAYSJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.18 045/183] drm/nv4c/mc: disable msi
Date: Sun, 25 Jan 2015 10:06:07 -0800
Message-Id: <20150125180812.125993203@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/subdev/mc/nv4c.c |    8 --------
 1 file changed, 8 deletions(-)

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
@@ -41,5 +34,4 @@ nv4c_mc_oclass = &(struct nouveau_mc_ocl
 		.fini = _nouveau_mc_fini,
 	},
 	.intr = nv04_mc_intr,
-	.msi_rearm = nv4c_mc_msi_rearm,
 }.base;


