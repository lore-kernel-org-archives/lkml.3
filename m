Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbaLWKk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:40:29 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12475 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbaLWKk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:40:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 23 Dec 2014 02:38:42 -0800
From: Vince Hsu <vinceh@nvidia.com>
To: thierry.reding@gmail.com, swarren@wwwdotorg.org, gnurou@gmail.com,
        bskeggs@redhat.com, martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com
CC: nouveau@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vince Hsu <vinceh@nvidia.com>
Subject: [PATCH nouveau 07/11] instmem: make nv50_instmem_priv public
Date: Tue, 23 Dec 2014 18:40:00 +0800
Message-ID: <1419331204-26679-8-git-send-email-vinceh@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GK20A needs to create a dummy instemem subdev to avoid suspend/resume
problem. So make the nv50_instmem_priv non-static for now.

Signed-off-by: Vince Hsu <vinceh@nvidia.com>
---
 drm/core/subdev/instmem/nv50.h |  1 +
 nvkm/subdev/instmem/nv50.c     |  9 ++-------
 nvkm/subdev/instmem/nv50.h     | 14 ++++++++++++++
 3 files changed, 17 insertions(+), 7 deletions(-)
 create mode 120000 drm/core/subdev/instmem/nv50.h
 create mode 100644 nvkm/subdev/instmem/nv50.h

diff --git a/drm/core/subdev/instmem/nv50.h b/drm/core/subdev/instmem/nv50.h
new file mode 120000
index 000000000000..043e22aee880
--- /dev/null
+++ b/drm/core/subdev/instmem/nv50.h
@@ -0,0 +1 @@
+../../../../nvkm/subdev/instmem/nv50.h
\ No newline at end of file
diff --git a/nvkm/subdev/instmem/nv50.c b/nvkm/subdev/instmem/nv50.c
index 7cb3b098a08d..66428b1c2394 100644
--- a/nvkm/subdev/instmem/nv50.c
+++ b/nvkm/subdev/instmem/nv50.c
@@ -25,14 +25,9 @@
 #include <subdev/fb.h>
 #include <core/mm.h>
 
+#include "nv50.h"
 #include "priv.h"
 
-struct nv50_instmem_priv {
-	struct nouveau_instmem base;
-	spinlock_t lock;
-	u64 addr;
-};
-
 struct nv50_instobj_priv {
 	struct nouveau_instobj base;
 	struct nouveau_mem *mem;
@@ -117,7 +112,7 @@ nv50_instobj_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 	return 0;
 }
 
-static struct nouveau_instobj_impl
+struct nouveau_instobj_impl
 nv50_instobj_oclass = {
 	.base.ofuncs = &(struct nouveau_ofuncs) {
 		.ctor = nv50_instobj_ctor,
diff --git a/nvkm/subdev/instmem/nv50.h b/nvkm/subdev/instmem/nv50.h
new file mode 100644
index 000000000000..bff03e3807ea
--- /dev/null
+++ b/nvkm/subdev/instmem/nv50.h
@@ -0,0 +1,14 @@
+#ifndef __NVKM_INSTMEM_NV50_H__
+#define __NVKM_INSTMEM_NV50_H__
+
+#include "priv.h"
+
+struct nv50_instmem_priv {
+	struct nouveau_instmem base;
+	spinlock_t lock;
+	u64 addr;
+};
+
+extern struct nouveau_instobj_impl nv50_instobj_oclass;
+
+#endif
-- 
1.9.1

