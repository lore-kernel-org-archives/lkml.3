Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbaAFO7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:59:21 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62712 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbaAFO7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:59:19 -0500
Date: Mon, 6 Jan 2014 20:29:12 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 05/85] drivers: gpu: Mark function as static in cirrus_main.c
Message-ID: <36eefa68c6748af85046b76f763afd332057da8f.1389018324.git.rashika.kheria@gmail.com>
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

Mark function cirrus_bo_unref() as static in drm/cirrus/cirrus_main.c
because it is not used outside this file.

This eliminates the following warning in drm/cirrus/cirrus_main.c:
drivers/gpu/drm/cirrus/cirrus_main.c:258:6: warning: no previous
prototype for ‘cirrus_bo_unref’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/cirrus/cirrus_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/cirrus/cirrus_main.c b/drivers/gpu/drm/cirrus/cirrus_main.c
index 78e76f2..4b0170c 100644
--- a/drivers/gpu/drm/cirrus/cirrus_main.c
+++ b/drivers/gpu/drm/cirrus/cirrus_main.c
@@ -255,7 +255,7 @@ int cirrus_dumb_create(struct drm_file *file,
 	return 0;
 }
 
-void cirrus_bo_unref(struct cirrus_bo **bo)
+static void cirrus_bo_unref(struct cirrus_bo **bo)
 {
 	struct ttm_buffer_object *tbo;
 
-- 
1.7.9.5

