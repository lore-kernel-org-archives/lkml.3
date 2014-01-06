Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaAFP2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:28:53 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:63999 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbaAFP2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:28:52 -0500
Date: Mon, 6 Jan 2014 20:58:45 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jerome Glisse <jglisse@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh2joshtriplett.org@rashika
Subject: [PATCH 28/85] drivers: gpu: Mark function as static in radeon_gem.c
Message-ID: <b7e582a2de3a8bbd7d763976aa6d8d58dcf9b9d2.1389018325.git.rashika.kheria@gmail.com>
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

Mark function radeon_gem_set_domain() as static in
drm/radeon/radeon_gem.c because it is not used outside this file.

This eliminates the following warning in drm/radeon/radeon_gem.c:
drivers/gpu/drm/radeon/radeon_gem.c:89:5: warning: no previous prototype for ‘radeon_gem_set_domain’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/radeon_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
index 805c5e5..b96c819 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -86,7 +86,7 @@ retry:
 	return 0;
 }
 
-int radeon_gem_set_domain(struct drm_gem_object *gobj,
+static int radeon_gem_set_domain(struct drm_gem_object *gobj,
 			  uint32_t rdomain, uint32_t wdomain)
 {
 	struct radeon_bo *robj;
-- 
1.7.9.5

