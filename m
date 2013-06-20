Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab3FTEab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 00:30:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38290 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab3FTEaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 00:30:30 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] firmware loader: fix compile warning with PM_SLEEP set
Date: Thu, 20 Jun 2013 12:30:16 +0800
Message-Id: <1371702616-6634-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the below compile warning:

drivers/base/firmware_class.c:1254:12: warning: 'cache_firmware' defined
but not used [-Wunused-function]
 static int cache_firmware(const char *fw_name)
            ^
drivers/base/firmware_class.c:1281:12: warning: 'uncache_firmware'
defined but not used [-Wunused-function]
 static int uncache_firmware(const char *fw_name)
            ^

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 7fefcb5..2b91b11 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1247,6 +1247,9 @@ request_firmware_nowait(
 }
 EXPORT_SYMBOL(request_firmware_nowait);
 
+#ifdef CONFIG_PM_SLEEP
+static ASYNC_DOMAIN_EXCLUSIVE(fw_cache_domain);
+
 /**
  * cache_firmware - cache one firmware image in kernel memory space
  * @fw_name: the firmware image name
@@ -1307,9 +1310,6 @@ static int uncache_firmware(const char *fw_name)
 	return -EINVAL;
 }
 
-#ifdef CONFIG_PM_SLEEP
-static ASYNC_DOMAIN_EXCLUSIVE(fw_cache_domain);
-
 static struct fw_cache_entry *alloc_fw_cache_entry(const char *name)
 {
 	struct fw_cache_entry *fce;
-- 
1.7.9.5

