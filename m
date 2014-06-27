Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaF0Udc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 16:33:32 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:58875 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbaF0Udb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 16:33:31 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AowOACPUrVNXQCoO/2dsb2JhbABbgw2rbwUBAQEBAQEFAW0Bl0uBN4ENF3WEYCOBGjeIRgHEUxeFZIkhHYQtBZpdiz+IPIIAgUQ7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Sumit Semwal <sumit.semwal@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 1/1] drivers/base/dma-buf.c: replace dma_buf_uninit_debugfs by debugfs_remove_recursive
Date: Fri, 27 Jun 2014 22:32:10 +0200
Message-Id: <1403901130-8156-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

null test before debugfs_remove_recursive is not needed so one line function
dma_buf_uninit_debugfs can be removed.

This patch calls debugfs_remove_recursive under CONFIG_DEBUG_FS

Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---

This is untested.

 drivers/base/dma-buf.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 840c7fa..184c0cb 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -701,12 +701,6 @@ static int dma_buf_init_debugfs(void)
 	return err;
 }
 
-static void dma_buf_uninit_debugfs(void)
-{
-	if (dma_buf_debugfs_dir)
-		debugfs_remove_recursive(dma_buf_debugfs_dir);
-}
-
 int dma_buf_debugfs_create_file(const char *name,
 				int (*write)(struct seq_file *))
 {
@@ -722,9 +716,6 @@ static inline int dma_buf_init_debugfs(void)
 {
 	return 0;
 }
-static inline void dma_buf_uninit_debugfs(void)
-{
-}
 #endif
 
 static int __init dma_buf_init(void)
@@ -738,6 +729,8 @@ subsys_initcall(dma_buf_init);
 
 static void __exit dma_buf_deinit(void)
 {
-	dma_buf_uninit_debugfs();
+#ifdef CONFIG_DEBUG_FS
+	debugfs_remove_recursive(dma_buf_debugfs_dir);
+#endif
 }
 __exitcall(dma_buf_deinit);
-- 
1.8.4.5

