Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab3LMWsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:48:52 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:44990 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab3LMW0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:23 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Greg Hackmann <ghackmann@google.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 011/115] gpu: ion: fill in buffer->{dev,size} before mapping new buffers
Date: Fri, 13 Dec 2013 14:23:45 -0800
Message-Id: <1386973529-4884-12-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Hackmann <ghackmann@google.com>

At least one map_dma() implementation (EXYNOS_CONTIG) assumes the fields
are filled in

Signed-off-by: Greg Hackmann <ghackmann@google.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 7ff9983..552a86a 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -151,6 +151,9 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 		return ERR_PTR(ret);
 	}
 
+	buffer->dev = dev;
+	buffer->size = len;
+
 	table = buffer->heap->ops->map_dma(buffer->heap, buffer);
 	if (IS_ERR_OR_NULL(table)) {
 		heap->ops->free(buffer);
@@ -159,8 +162,6 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 	}
 	buffer->sg_table = table;
 
-	buffer->dev = dev;
-	buffer->size = len;
 	mutex_init(&buffer->lock);
 	ion_buffer_add(dev, buffer);
 	return buffer;
-- 
1.8.3.2

