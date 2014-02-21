Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbaBUNvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:51:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46840 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbaBUMtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:51 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 031/121] drm/mgag200,ast,cirrus: fix regression with drm_can_sleep conversion
Date: Fri, 21 Feb 2014 12:47:35 +0000
Message-Id: <1392986945-9693-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 8b7ad1bb3d440da888f2a939dc870eba429b9192 upstream.

I totally sign inverted my way out of this one.

Reported-by: "Sabrina Dubroca" <sd@queasysnail.net>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/ast/ast_fb.c          | 2 +-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c | 2 +-
 drivers/gpu/drm/mgag200/mgag200_fb.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_fb.c b/drivers/gpu/drm/ast/ast_fb.c
index 3f65dd6..a28640f 100644
--- a/drivers/gpu/drm/ast/ast_fb.c
+++ b/drivers/gpu/drm/ast/ast_fb.c
@@ -65,7 +65,7 @@ static void ast_dirty_update(struct ast_fbdev *afbdev,
 	 * then the BO is being moved and we should
 	 * store up the damage until later.
 	 */
-	if (!drm_can_sleep())
+	if (drm_can_sleep())
 		ret = ast_bo_reserve(bo, true);
 	if (ret) {
 		if (ret != -EBUSY)
diff --git a/drivers/gpu/drm/cirrus/cirrus_fbdev.c b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
index 6c16de3..86d779a 100644
--- a/drivers/gpu/drm/cirrus/cirrus_fbdev.c
+++ b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
@@ -39,7 +39,7 @@ static void cirrus_dirty_update(struct cirrus_fbdev *afbdev,
 	 * then the BO is being moved and we should
 	 * store up the damage until later.
 	 */
-	if (!drm_can_sleep())
+	if (drm_can_sleep())
 		ret = cirrus_bo_reserve(bo, true);
 	if (ret) {
 		if (ret != -EBUSY)
diff --git a/drivers/gpu/drm/mgag200/mgag200_fb.c b/drivers/gpu/drm/mgag200/mgag200_fb.c
index 17cea9f..d29bb33 100644
--- a/drivers/gpu/drm/mgag200/mgag200_fb.c
+++ b/drivers/gpu/drm/mgag200/mgag200_fb.c
@@ -41,7 +41,7 @@ static void mga_dirty_update(struct mga_fbdev *mfbdev,
 	 * then the BO is being moved and we should
 	 * store up the damage until later.
 	 */
-	if (!drm_can_sleep())
+	if (drm_can_sleep())
 		ret = mgag200_bo_reserve(bo, true);
 	if (ret) {
 		if (ret != -EBUSY)
-- 
1.9.0

