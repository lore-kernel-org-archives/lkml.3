Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbaKJREO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:04:14 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47396 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbaKJREM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:04:12 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 2/2] media: cx88: use vb2_start_streaming_called() helper
Date: Mon, 10 Nov 2014 16:55:54 +0000
Message-Id: <1415638554-13362-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415638554-13362-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1415638554-13362-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch adds support for using vb2_start_streaming_called()
for cx88-blackbird driver.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/pci/cx88/cx88-blackbird.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index ff79782..4160ca4 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -881,7 +881,7 @@ static int vidioc_s_frequency (struct file *file, void *priv,
 		return -EINVAL;
 	if (unlikely(f->tuner != 0))
 		return -EINVAL;
-	streaming = dev->vb2_mpegq.start_streaming_called;
+	streaming = vb2_start_streaming_called(&dev->vb2_mpegq);
 	if (streaming)
 		blackbird_stop_codec(dev);
 
-- 
1.9.1

