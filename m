Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162506Ab3LFNo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:44:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44201 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215Ab3LFNCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jakob Bornecrantz <jakob@vmware.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thellstrom@vmware.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 136/272] drm/ttm: Handle in-memory region copies
Date: Fri,  6 Dec 2013 12:57:05 +0000
Message-Id: <1386334761-25517-137-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakob Bornecrantz <jakob@vmware.com>

commit 9a0599ddeae012a771bba5e23393fc52d8a59d89 upstream.

Fix the case where the ttm pointer may be NULL causing
a NULL pointer dereference.

Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Thomas Hellström <thellstrom@vmware.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 319cf41..657aeb2 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -347,7 +347,9 @@ int ttm_bo_move_memcpy(struct ttm_buffer_object *bo,
 	if (old_iomap == NULL && ttm == NULL)
 		goto out2;
 
-	if (ttm->state == tt_unpopulated) {
+	/* TTM might be null for moves within the same region.
+	 */
+	if (ttm && ttm->state == tt_unpopulated) {
 		ret = ttm->bdev->driver->ttm_tt_populate(ttm);
 		if (ret) {
 			/* if we fail here don't nuke the mm node
-- 
1.8.3.2

