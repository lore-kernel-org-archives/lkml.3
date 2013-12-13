Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab3LMW0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:26:40 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:45448 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab3LMW0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:38 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 021/115] gpu: ion: Add EXPORT_SYMBOL to functions
Date: Fri, 13 Dec 2013 14:23:55 -0800
Message-Id: <1386973529-4884-22-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olav Haugan <ohaugan@codeaurora.org>

Several functions in the ion interface is missing
EXPORT_SYMBOL. This is needed to allow clients to
use these functions from kernel modules.

Add EXPORT_SYMBOL to functions that are supposed
to be exposed.

Signed-off-by: Olav Haugan <ohaugan@codeaurora.org>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 5872dd3..f536ce5 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -396,6 +396,7 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 
 	return handle;
 }
+EXPORT_SYMBOL(ion_alloc);
 
 void ion_free(struct ion_client *client, struct ion_handle *handle)
 {
@@ -413,6 +414,7 @@ void ion_free(struct ion_client *client, struct ion_handle *handle)
 	}
 	ion_handle_put(handle);
 }
+EXPORT_SYMBOL(ion_free);
 
 int ion_phys(struct ion_client *client, struct ion_handle *handle,
 	     ion_phys_addr_t *addr, size_t *len)
@@ -438,6 +440,7 @@ int ion_phys(struct ion_client *client, struct ion_handle *handle,
 	ret = buffer->heap->ops->phys(buffer->heap, buffer, addr, len);
 	return ret;
 }
+EXPORT_SYMBOL(ion_phys);
 
 static void *ion_buffer_kmap_get(struct ion_buffer *buffer)
 {
@@ -517,6 +520,7 @@ void *ion_map_kernel(struct ion_client *client, struct ion_handle *handle)
 	mutex_unlock(&client->lock);
 	return vaddr;
 }
+EXPORT_SYMBOL(ion_map_kernel);
 
 void ion_unmap_kernel(struct ion_client *client, struct ion_handle *handle)
 {
@@ -529,6 +533,7 @@ void ion_unmap_kernel(struct ion_client *client, struct ion_handle *handle)
 	mutex_unlock(&buffer->lock);
 	mutex_unlock(&client->lock);
 }
+EXPORT_SYMBOL(ion_unmap_kernel);
 
 static int ion_debug_client_show(struct seq_file *s, void *unused)
 {
@@ -654,6 +659,7 @@ void ion_client_destroy(struct ion_client *client)
 
 	kfree(client);
 }
+EXPORT_SYMBOL(ion_client_destroy);
 
 struct sg_table *ion_sg_table(struct ion_client *client,
 			      struct ion_handle *handle)
@@ -673,6 +679,7 @@ struct sg_table *ion_sg_table(struct ion_client *client,
 	mutex_unlock(&client->lock);
 	return table;
 }
+EXPORT_SYMBOL(ion_sg_table);
 
 static void ion_buffer_sync_for_device(struct ion_buffer *buffer,
 				       struct device *dev,
@@ -924,6 +931,7 @@ int ion_share_dma_buf(struct ion_client *client, struct ion_handle *handle)
 	}
 	return fd;
 }
+EXPORT_SYMBOL(ion_share_dma_buf);
 
 struct ion_handle *ion_import_dma_buf(struct ion_client *client, int fd)
 {
@@ -960,6 +968,7 @@ end:
 	dma_buf_put(dmabuf);
 	return handle;
 }
+EXPORT_SYMBOL(ion_import_dma_buf);
 
 static int ion_sync_for_device(struct ion_client *client, int fd)
 {
-- 
1.8.3.2

