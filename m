Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaAFPNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:13:22 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:49457 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbaAFPNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:13:21 -0500
Date: Mon, 6 Jan 2014 20:43:16 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Christoph Bumiller <e0425955@student.tuwien.ac.at>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 16/85] drivers: gpu: Mark functions as static in nvc0.c
Message-ID: <6ca3f0d014db1457fd6a95b7b99e3f16c6ddcffc.1389018324.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions nvc0_graph_init_fw() and nvc0_graph_ctor_fw() as static
in drm/nouveau/core/engine/graph/nvc0.c because they are not used
outside this file.

This eliminates the following warning in
drm/nouveau/core/engine/graph/nvc0.c:
drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c:756:1: warning: no previous prototype for ‘nvc0_graph_init_fw’ [-Wmissing-prototypes]
drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c:1082:1: warning: no previous prototype for ‘nvc0_graph_ctor_fw’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
index 434bb4b..8d895a9 100644
--- a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
@@ -752,7 +752,7 @@ nvc0_graph_intr(struct nouveau_subdev *subdev)
 	nouveau_engctx_put(engctx);
 }
 
-void
+static void
 nvc0_graph_init_fw(struct nvc0_graph_priv *priv, u32 fuc_base,
 		   struct nvc0_graph_fuc *code, struct nvc0_graph_fuc *data)
 {
@@ -1078,7 +1078,7 @@ nvc0_graph_dtor_fw(struct nvc0_graph_fuc *fuc)
 	fuc->data = NULL;
 }
 
-int
+static int
 nvc0_graph_ctor_fw(struct nvc0_graph_priv *priv, const char *fwname,
 		   struct nvc0_graph_fuc *fuc)
 {
-- 
1.7.9.5

