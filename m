Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaBJUIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:08:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34820 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbaBJTpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:45:18 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 098/124] drm: ast,cirrus,mgag200: use drm_can_sleep
Date: Mon, 10 Feb 2014 11:40:38 -0800
Message-Id: <1392061264-28124-99-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit f4b4718b61d1d5a7442a4fd6863ea80c3a10e508 upstream.

these 3 were checking in_interrupt but we have situations where
calling vunmap under this could cause a BUG to be hit in
smp_call_function_many. Use the drm_can_sleep macro instead,
which should stop this path from been taken in this case.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/ast/ast_fb.c          | 2 +-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c | 2 +-
 drivers/gpu/drm/mgag200/mgag200_fb.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_fb.c b/drivers/gpu/drm/ast/ast_fb.c
index 66ecc16..d56d2bf 100644
--- a/drivers/gpu/drm/ast/ast_fb.c
+++ b/drivers/gpu/drm/ast/ast_fb.c
@@ -64,7 +64,7 @@ static void ast_dirty_update(struct ast_fbdev *afbdev,
 	 * then the BO is being moved and we should
 	 * store up the damage until later.
 	 */
-	if (!in_interrupt())
+	if (!drm_can_sleep())
 		ret = ast_bo_reserve(bo, true);
 	if (ret) {
 		if (ret != -EBUSY)
diff --git a/drivers/gpu/drm/cirrus/cirrus_fbdev.c b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
index 4202ff5..68460cb 100644
--- a/drivers/gpu/drm/cirrus/cirrus_fbdev.c
+++ b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
@@ -38,7 +38,7 @@ static void cirrus_dirty_update(struct cirrus_fbdev *afbdev,
 	 * then the BO is being moved and we should
 	 * store up the damage until later.
 	 */
-	if (!in_interrupt())
+	if (!drm_can_sleep())
 		ret = cirrus_bo_reserve(bo, true);
 	if (ret) {
 		if (ret != -EBUSY)
diff --git a/drivers/gpu/drm/mgag200/mgag200_fb.c b/drivers/gpu/drm/mgag200/mgag200_fb.c
index 0cbd607..675ccf5 100644
--- a/drivers/gpu/drm/mgag200/mgag200_fb.c
+++ b/drivers/gpu/drm/mgag200/mgag200_fb.c
@@ -40,7 +40,7 @@ static void mga_dirty_update(struct mga_fbdev *mfbdev,
 	 * then the BO is being moved and we should
 	 * store up the damage until later.
 	 */
-	if (!in_interrupt())
+	if (!drm_can_sleep())
 		ret = mgag200_bo_reserve(bo, true);
 	if (ret) {
 		if (ret != -EBUSY)
-- 
1.8.3.2

