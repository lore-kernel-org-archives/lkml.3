Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaCCS4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:56:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55850 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbaCCS4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:56:14 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 16/67] drm/mgag200,ast,cirrus: fix regression with drm_can_sleep conversion
Date: Mon,  3 Mar 2014 10:55:04 -0800
Message-Id: <1393872955-28810-17-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 8b7ad1bb3d440da888f2a939dc870eba429b9192 upstream.

I totally sign inverted my way out of this one.

Reported-by: "Sabrina Dubroca" <sd@queasysnail.net>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/ast/ast_fb.c          | 2 +-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c | 2 +-
 drivers/gpu/drm/mgag200/mgag200_fb.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_fb.c b/drivers/gpu/drm/ast/ast_fb.c
index d56d2bf..215a3ce2 100644
--- a/drivers/gpu/drm/ast/ast_fb.c
+++ b/drivers/gpu/drm/ast/ast_fb.c
@@ -64,7 +64,7 @@ static void ast_dirty_update(struct ast_fbdev *afbdev,
 	 * then the BO is being moved and we should
 	 * store up the damage until later.
 	 */
-	if (!drm_can_sleep())
+	if (drm_can_sleep())
 		ret = ast_bo_reserve(bo, true);
 	if (ret) {
 		if (ret != -EBUSY)
diff --git a/drivers/gpu/drm/cirrus/cirrus_fbdev.c b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
index 68460cb..9a83396 100644
--- a/drivers/gpu/drm/cirrus/cirrus_fbdev.c
+++ b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
@@ -38,7 +38,7 @@ static void cirrus_dirty_update(struct cirrus_fbdev *afbdev,
 	 * then the BO is being moved and we should
 	 * store up the damage until later.
 	 */
-	if (!drm_can_sleep())
+	if (drm_can_sleep())
 		ret = cirrus_bo_reserve(bo, true);
 	if (ret) {
 		if (ret != -EBUSY)
diff --git a/drivers/gpu/drm/mgag200/mgag200_fb.c b/drivers/gpu/drm/mgag200/mgag200_fb.c
index 675ccf5..7ac725c 100644
--- a/drivers/gpu/drm/mgag200/mgag200_fb.c
+++ b/drivers/gpu/drm/mgag200/mgag200_fb.c
@@ -40,7 +40,7 @@ static void mga_dirty_update(struct mga_fbdev *mfbdev,
 	 * then the BO is being moved and we should
 	 * store up the damage until later.
 	 */
-	if (!drm_can_sleep())
+	if (drm_can_sleep())
 		ret = mgag200_bo_reserve(bo, true);
 	if (ret) {
 		if (ret != -EBUSY)
-- 
1.8.3.2

