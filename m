Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab3LSJlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:41:22 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:48170 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3LSJlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:41:20 -0500
Date: Thu, 19 Dec 2013 15:11:09 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
        josh@joshtriplett.org
Subject: [PATCH 06/13] drivers: block: Mark functions as static in
 drbd_receiver.c
Message-ID: <fe63e86117a10a434e59db1222b3b08b015551a2.1387445396.git.rashika.kheria@gmail.com>
References: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions conn_wait_active_ee_empty() and
drbd_crypto_alloc_digest_safe() as static in drbd/drbd_receiver.c
because they are not used outside this file.

This eliminates the following warning in drbd/drbd_receiver.c:
drivers/block/drbd/drbd_receiver.c:1401:6: warning: no previous prototype for ‘conn_wait_active_ee_empty’ [-Wmissing-prototypes]
drivers/block/drbd/drbd_receiver.c:3259:21: warning: no previous prototype for ‘drbd_crypto_alloc_digest_safe’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/block/drbd/drbd_receiver.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 6fa6673..c31c7a2 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1398,7 +1398,7 @@ static void drbd_remove_epoch_entry_interval(struct drbd_conf *mdev,
 		wake_up(&mdev->misc_wait);
 }
 
-void conn_wait_active_ee_empty(struct drbd_tconn *tconn)
+static void conn_wait_active_ee_empty(struct drbd_tconn *tconn)
 {
 	struct drbd_conf *mdev;
 	int vnr;
@@ -3256,6 +3256,7 @@ disconnect:
  * return: NULL (alg name was "")
  *         ERR_PTR(error) if something goes wrong
  *         or the crypto hash ptr, if it worked out ok. */
+static
 struct crypto_hash *drbd_crypto_alloc_digest_safe(const struct drbd_conf *mdev,
 		const char *alg, const char *name)
 {
-- 
1.7.9.5

