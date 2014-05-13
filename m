Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbaEMX41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 19:56:27 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56163 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbaEMX4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 19:56:25 -0400
X-Original-SENDERIP: 165.186.175.39
X-Original-MAILFROM: gioh.kim@lge.com
From: Gioh Kim <gioh.kim@lge.com>
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: gunho.lee@lge.com, Gioh Kim <gioh.kim@lge.com>
Subject: [PATCH] Documentation/dma-buf-sharing.txt: update API descriptions
Date: Wed, 14 May 2014 08:49:43 +0900
Message-Id: <1400024983-21891-1-git-send-email-gioh.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update some descriptions for API arguments and descriptions.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 Documentation/dma-buf-sharing.txt |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
index 505e711..aadd901 100644
--- a/Documentation/dma-buf-sharing.txt
+++ b/Documentation/dma-buf-sharing.txt
@@ -56,10 +56,10 @@ The dma_buf buffer sharing API usage contains the following steps:
 				     size_t size, int flags,
 				     const char *exp_name)
 
-   If this succeeds, dma_buf_export allocates a dma_buf structure, and returns a
-   pointer to the same. It also associates an anonymous file with this buffer,
-   so it can be exported. On failure to allocate the dma_buf object, it returns
-   NULL.
+   If this succeeds, dma_buf_export_named allocates a dma_buf structure, and
+   returns a pointer to the same. It also associates an anonymous file with this
+   buffer, so it can be exported. On failure to allocate the dma_buf object,
+   it returns NULL.
 
    'exp_name' is the name of exporter - to facilitate information while
    debugging.
@@ -76,7 +76,7 @@ The dma_buf buffer sharing API usage contains the following steps:
    drivers and/or processes.
 
    Interface:
-      int dma_buf_fd(struct dma_buf *dmabuf)
+      int dma_buf_fd(struct dma_buf *dmabuf, int flags)
 
    This API installs an fd for the anonymous file associated with this buffer;
    returns either 'fd', or error.
@@ -157,7 +157,9 @@ to request use of buffer for allocation.
    "dma_buf->ops->" indirection from the users of this interface.
 
    In struct dma_buf_ops, unmap_dma_buf is defined as
-      void (*unmap_dma_buf)(struct dma_buf_attachment *, struct sg_table *);
+      void (*unmap_dma_buf)(struct dma_buf_attachment *,
+                            struct sg_table *,
+                            enum dma_data_direction);
 
    unmap_dma_buf signifies the end-of-DMA for the attachment provided. Like
    map_dma_buf, this API also must be implemented by the exporter.
-- 
1.7.9.5

