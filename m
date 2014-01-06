Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbaAFPPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:15:03 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:46667 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbaAFPPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:15:01 -0500
Date: Mon, 6 Jan 2014 20:44:54 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 17/85] drivers: gpu: Mark function as static in base.c
Message-ID: <465cb6bfad1a5fec971042a08de8dc62aae13a73.1389018324.git.rashika.kheria@gmail.com>
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

Mark function nouveau_perfsig_find() as static in
drm/nouveau/core/engine/perfmon/base.c because it is not used outside
this file.

This eliminates the following warning in
drm/nouveau/core/engine/perfmon/base.c:
drivers/gpu/drm/nouveau/core/engine/perfmon/base.c:59:1: warning: no previous prototype for ‘nouveau_perfsig_find’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/nouveau/core/engine/perfmon/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/perfmon/base.c b/drivers/gpu/drm/nouveau/core/engine/perfmon/base.c
index e9c5e51..1778c96 100644
--- a/drivers/gpu/drm/nouveau/core/engine/perfmon/base.c
+++ b/drivers/gpu/drm/nouveau/core/engine/perfmon/base.c
@@ -55,7 +55,7 @@ nouveau_perfsig_find_(struct nouveau_perfdom *dom, const char *name, u32 size)
 	return NULL;
 }
 
-struct nouveau_perfsig *
+static struct nouveau_perfsig *
 nouveau_perfsig_find(struct nouveau_perfmon *ppm, const char *name, u32 size,
 		     struct nouveau_perfdom **pdom)
 {
-- 
1.7.9.5

