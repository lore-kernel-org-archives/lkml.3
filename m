Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab3FFMCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:02:15 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:59470 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584Ab3FFMCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:02:12 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v1 1/4] firmware loader: don't export cache_firmware and uncache_firmware
Date: Thu,  6 Jun 2013 20:01:47 +0800
Message-Id: <1370520110-32293-2-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370520110-32293-1-git-send-email-ming.lei@canonical.com>
References: <1370520110-32293-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks no driver has the explict requirement for the two exported
API, just don't export them anymore.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |    6 ++----
 include/linux/firmware.h      |   11 -----------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 47e3a22..caaddef 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1244,7 +1244,7 @@ EXPORT_SYMBOL(request_firmware_nowait);
  * Return !0 otherwise
  *
  */
-int cache_firmware(const char *fw_name)
+static int cache_firmware(const char *fw_name)
 {
 	int ret;
 	const struct firmware *fw;
@@ -1259,7 +1259,6 @@ int cache_firmware(const char *fw_name)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(cache_firmware);
 
 /**
  * uncache_firmware - remove one cached firmware image
@@ -1272,7 +1271,7 @@ EXPORT_SYMBOL_GPL(cache_firmware);
  * Return !0 otherwise
  *
  */
-int uncache_firmware(const char *fw_name)
+static int uncache_firmware(const char *fw_name)
 {
 	struct firmware_buf *buf;
 	struct firmware fw;
@@ -1290,7 +1289,6 @@ int uncache_firmware(const char *fw_name)
 
 	return -EINVAL;
 }
-EXPORT_SYMBOL_GPL(uncache_firmware);
 
 #ifdef CONFIG_PM_SLEEP
 static ASYNC_DOMAIN_EXCLUSIVE(fw_cache_domain);
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index e4279fe..e154c10 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -47,8 +47,6 @@ int request_firmware_nowait(
 	void (*cont)(const struct firmware *fw, void *context));
 
 void release_firmware(const struct firmware *fw);
-int cache_firmware(const char *name);
-int uncache_firmware(const char *name);
 #else
 static inline int request_firmware(const struct firmware **fw,
 				   const char *name,
@@ -68,15 +66,6 @@ static inline void release_firmware(const struct firmware *fw)
 {
 }
 
-static inline int cache_firmware(const char *name)
-{
-	return -ENOENT;
-}
-
-static inline int uncache_firmware(const char *name)
-{
-	return -EINVAL;
-}
 #endif
 
 #endif
-- 
1.7.9.5

