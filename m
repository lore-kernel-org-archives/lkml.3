Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbaBGMJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:09:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42311 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462AbaBGLv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 186/233] drm: ast,cirrus,mgag200: use drm_can_sleep
Date: Fri,  7 Feb 2014 11:46:45 +0000
Message-Id: <1391773652-25214-187-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit f4b4718b61d1d5a7442a4fd6863ea80c3a10e508 upstream.

these 3 were checking in_interrupt but we have situations where
calling vunmap under this could cause a BUG to be hit in
smp_call_function_many. Use the drm_can_sleep macro instead,
which should stop this path from been taken in this case.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/ast/ast_fb.c          | 2 +-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c | 2 +-
 drivers/gpu/drm/mgag200/mgag200_fb.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_fb.c b/drivers/gpu/drm/ast/ast_fb.c
index 7b33e14..3f65dd6 100644
--- a/drivers/gpu/drm/ast/ast_fb.c
+++ b/drivers/gpu/drm/ast/ast_fb.c
@@ -65,7 +65,7 @@ static void ast_dirty_update(struct ast_fbdev *afbdev,
 	 * then the BO is being moved and we should
 	 * store up the damage until later.
 	 */
-	if (!in_interrupt())
+	if (!drm_can_sleep())
 		ret = ast_bo_reserve(bo, true);
 	if (ret) {
 		if (ret != -EBUSY)
diff --git a/drivers/gpu/drm/cirrus/cirrus_fbdev.c b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
index b27e956..6c16de3 100644
--- a/drivers/gpu/drm/cirrus/cirrus_fbdev.c
+++ b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
@@ -39,7 +39,7 @@ static void cirrus_dirty_update(struct cirrus_fbdev *afbdev,
 	 * then the BO is being moved and we should
 	 * store up the damage until later.
 	 */
-	if (!in_interrupt())
+	if (!drm_can_sleep())
 		ret = cirrus_bo_reserve(bo, true);
 	if (ret) {
 		if (ret != -EBUSY)
diff --git a/drivers/gpu/drm/mgag200/mgag200_fb.c b/drivers/gpu/drm/mgag200/mgag200_fb.c
index 964f58c..17cea9f 100644
--- a/drivers/gpu/drm/mgag200/mgag200_fb.c
+++ b/drivers/gpu/drm/mgag200/mgag200_fb.c
@@ -41,7 +41,7 @@ static void mga_dirty_update(struct mga_fbdev *mfbdev,
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

