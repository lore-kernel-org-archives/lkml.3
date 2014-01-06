Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbaAFQqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:46:03 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56093 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbaAFQqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:46:01 -0500
Date: Mon, 6 Jan 2014 22:15:56 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 80/85] drivers: gpu: Remove unused function in ttm_lock.c
Message-ID: <c28adb84eb620999b1b8c2b98546c36639dce08a.1389018325.git.rashika.kheria@gmail.com>
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

Remove unused function ttm_write_lock_downgrade() from
drm/ttm/ttm_lock.c.

This eliminates the following warning in drm/ttm/ttm_lock.c:
drivers/gpu/drm/ttm/ttm_lock.c:189:6: warning: no previous prototype for ‘ttm_write_lock_downgrade’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/ttm/ttm_lock.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_lock.c b/drivers/gpu/drm/ttm/ttm_lock.c
index 3daa9a3..6a95454 100644
--- a/drivers/gpu/drm/ttm/ttm_lock.c
+++ b/drivers/gpu/drm/ttm/ttm_lock.c
@@ -186,14 +186,6 @@ int ttm_write_lock(struct ttm_lock *lock, bool interruptible)
 }
 EXPORT_SYMBOL(ttm_write_lock);
 
-void ttm_write_lock_downgrade(struct ttm_lock *lock)
-{
-	spin_lock(&lock->lock);
-	lock->rw = 1;
-	wake_up_all(&lock->queue);
-	spin_unlock(&lock->lock);
-}
-
 static int __ttm_vt_unlock(struct ttm_lock *lock)
 {
 	int ret = 0;
-- 
1.7.9.5

