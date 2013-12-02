Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab3LBU6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:58:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab3LBTNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jakob Bornecrantz <jakob@vmware.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thellstrom@vmware.com>
Subject: [PATCH 3.10 095/173] drm/ttm: Handle in-memory region copies
Date: Mon,  2 Dec 2013 11:11:18 -0800
Message-Id: <20131202191154.854087877@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakob Bornecrantz <jakob@vmware.com>

commit 9a0599ddeae012a771bba5e23393fc52d8a59d89 upstream.

Fix the case where the ttm pointer may be NULL causing
a NULL pointer dereference.

Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Thomas Hellström <thellstrom@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ttm/ttm_bo_util.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -347,7 +347,9 @@ int ttm_bo_move_memcpy(struct ttm_buffer
 	if (old_iomap == NULL && ttm == NULL)
 		goto out2;
 
-	if (ttm->state == tt_unpopulated) {
+	/* TTM might be null for moves within the same region.
+	 */
+	if (ttm && ttm->state == tt_unpopulated) {
 		ret = ttm->bdev->driver->ttm_tt_populate(ttm);
 		if (ret) {
 			/* if we fail here don't nuke the mm node


