Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab3FZB2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:28:51 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:42140 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3FZB2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:28:50 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] firmwar loader: fix another compile warning with PM_SLEEP unset
Date: Wed, 26 Jun 2013 09:28:17 +0800
Message-Id: <1372210097-11840-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes another compiling warning with PM_SLEEP unset:

drivers/base/firmware_class.c:221:29: warning: 'fw_lookup_buf' defined
but not used [-Wunused-function]

This time I do build kernel with both PM_SLEEP set and unset, and no
warning found any more with the patch.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 2b91b11..a439602 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -218,18 +218,6 @@ static int fw_lookup_and_allocate_buf(const char *fw_name,
 	return tmp ? 0 : -ENOMEM;
 }
 
-static struct firmware_buf *fw_lookup_buf(const char *fw_name)
-{
-	struct firmware_buf *tmp;
-	struct firmware_cache *fwc = &fw_cache;
-
-	spin_lock(&fwc->lock);
-	tmp = __fw_lookup_buf(fw_name);
-	spin_unlock(&fwc->lock);
-
-	return tmp;
-}
-
 static void __fw_free_buf(struct kref *ref)
 {
 	struct firmware_buf *buf = to_fwbuf(ref);
@@ -1280,6 +1268,18 @@ static int cache_firmware(const char *fw_name)
 	return ret;
 }
 
+static struct firmware_buf *fw_lookup_buf(const char *fw_name)
+{
+	struct firmware_buf *tmp;
+	struct firmware_cache *fwc = &fw_cache;
+
+	spin_lock(&fwc->lock);
+	tmp = __fw_lookup_buf(fw_name);
+	spin_unlock(&fwc->lock);
+
+	return tmp;
+}
+
 /**
  * uncache_firmware - remove one cached firmware image
  * @fw_name: the firmware image name
-- 
1.7.9.5

