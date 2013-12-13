Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab3LMWow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:44:52 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38310 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab3LMW0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:46 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Greg Hackmann <ghackmann@google.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 026/115] gpu: ion: fix page offset in dma_buf_kmap()
Date: Fri, 13 Dec 2013 14:24:00 -0800
Message-Id: <1386973529-4884-27-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Hackmann <ghackmann@google.com>

Signed-off-by: Greg Hackmann <ghackmann@google.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 4d91d20..84229bd 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -846,7 +846,7 @@ static void ion_dma_buf_release(struct dma_buf *dmabuf)
 static void *ion_dma_buf_kmap(struct dma_buf *dmabuf, unsigned long offset)
 {
 	struct ion_buffer *buffer = dmabuf->priv;
-	return buffer->vaddr + offset;
+	return buffer->vaddr + offset * PAGE_SIZE;
 }
 
 static void ion_dma_buf_kunmap(struct dma_buf *dmabuf, unsigned long offset,
-- 
1.8.3.2

