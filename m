Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbaAFPZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:25:36 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63398 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaAFPZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:25:35 -0500
Date: Mon, 6 Jan 2014 20:55:28 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>,
        aarten Lankhorst <maarten.lankhorst@canonical.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 25/85] drivers: gpu: Mark function as static in
 radeon_object.c
Message-ID: <8eb1c0ab2bdc2565f59e4869406fa53a5fd22ba9.1389018325.git.rashika.kheria@gmail.com>
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

Mark function radeon_bo_clear_va() as static in
drm/radeon/radeon_object.c because it is not used outside this file.

This eliminates the following warning in drm/radeon/radeon_object.c:
drivers/gpu/drm/radeon/radeon_object.c:49:6: warning: no previous prototype for ‘radeon_bo_clear_va’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/radeon_object.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index 2543430..4820cc8 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -44,7 +44,7 @@ static void radeon_bo_clear_surface_reg(struct radeon_bo *bo);
  * function are calling it.
  */
 
-void radeon_bo_clear_va(struct radeon_bo *bo)
+static void radeon_bo_clear_va(struct radeon_bo *bo)
 {
 	struct radeon_bo_va *bo_va, *tmp;
 
-- 
1.7.9.5

