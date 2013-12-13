Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3LMW01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:26:27 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:63784 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3LMW0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:22 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 010/115] gpu: ion: Get an sg_table from an ion handle
Date: Fri, 13 Dec 2013 14:23:44 -0800
Message-Id: <1386973529-4884-11-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

This patch adds an interface to return and sg_table given a
valid ion handle.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c |  8 ++------
 drivers/staging/android/ion/ion.h | 13 ++++++++++++-
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index b95202b..7ff9983 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -616,8 +616,8 @@ void ion_client_destroy(struct ion_client *client)
 	kfree(client);
 }
 
-struct sg_table *ion_map_dma(struct ion_client *client,
-			     struct ion_handle *handle)
+struct sg_table *ion_sg_table(struct ion_client *client,
+			      struct ion_handle *handle)
 {
 	struct ion_buffer *buffer;
 	struct sg_table *table;
@@ -635,10 +635,6 @@ struct sg_table *ion_map_dma(struct ion_client *client,
 	return table;
 }
 
-void ion_unmap_dma(struct ion_client *client, struct ion_handle *handle)
-{
-}
-
 static struct sg_table *ion_map_dma_buf(struct dma_buf_attachment *attachment,
 					enum dma_data_direction direction)
 {
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index 84ca2a9..28810c8 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -149,7 +149,7 @@ void ion_free(struct ion_client *client, struct ion_handle *handle);
  * This function queries the heap for a particular handle to get the
  * handle's physical address.  It't output is only correct if
  * a heap returns physically contiguous memory -- in other cases
- * this api should not be implemented -- ion_map_dma should be used
+ * this api should not be implemented -- ion_sg_table should be used
  * instead.  Returns -EINVAL if the handle is invalid.  This has
  * no implications on the reference counting of the handle --
  * the returned value may not be valid if the caller is not
@@ -159,6 +159,17 @@ int ion_phys(struct ion_client *client, struct ion_handle *handle,
 	     ion_phys_addr_t *addr, size_t *len);
 
 /**
+ * ion_map_dma - return an sg_table describing a handle
+ * @client:	the client
+ * @handle:	the handle
+ *
+ * This function returns the sg_table describing
+ * a particular ion handle.
+ */
+struct sg_table *ion_sg_table(struct ion_client *client,
+			      struct ion_handle *handle);
+
+/**
  * ion_map_kernel - create mapping for the given handle
  * @client:	the client
  * @handle:	handle to map
-- 
1.8.3.2

