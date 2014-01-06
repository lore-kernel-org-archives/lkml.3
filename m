Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbaAFPGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:06:32 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:35755 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbaAFPGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:06:30 -0500
Date: Mon, 6 Jan 2014 20:36:15 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christopher Harvey <charvey@matrox.com>,
        Julia Lemire <jlemire@matrox.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtripeltt.org
Subject: [PATCH 10/85] drivers: gpu: Mark function as static in mgag200_main.c
Message-ID: <775ccc112aac17eaea1e0073d675246f351f07ff.1389018324.git.rashika.kheria@gmail.com>
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

Mark function mgag200_bo_unref() as static in drm/mgag200/mgag200_main.c
because it is not used outside this file.

This eliminates the following warning in drm/mgag200/mgag200_main.c:
drivers/gpu/drm/mgag200/mgag200_main.c:313:6: warning: no previous prototype for ‘mgag200_bo_unref’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/mgag200/mgag200_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_main.c b/drivers/gpu/drm/mgag200/mgag200_main.c
index b1120cb..a1bfe72 100644
--- a/drivers/gpu/drm/mgag200/mgag200_main.c
+++ b/drivers/gpu/drm/mgag200/mgag200_main.c
@@ -310,7 +310,7 @@ int mgag200_dumb_create(struct drm_file *file,
 	return 0;
 }
 
-void mgag200_bo_unref(struct mgag200_bo **bo)
+static void mgag200_bo_unref(struct mgag200_bo **bo)
 {
 	struct ttm_buffer_object *tbo;
 
-- 
1.7.9.5

