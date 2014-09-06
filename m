Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaIFP1w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 11:27:52 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:52896 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaIFP1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 11:27:44 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 3/5] media: videobuf2-core.h: add a helper to get status of start_streaming()
Date: Sat,  6 Sep 2014 16:26:49 +0100
Message-Id: <1410017211-15438-4-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410017211-15438-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1410017211-15438-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch adds a helper to get the status if start_streaming()
was called successfully.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/videobuf2-core.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 5a10d8d..b3c9973 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -590,6 +590,15 @@ vb2_plane_size(struct vb2_buffer *vb, unsigned int plane_no)
 	return 0;
 }
 
+/**
+ * vb2_start_streaming_called() - return streaming status of driver
+ * @q:		videobuf queue
+ */
+static inline bool vb2_start_streaming_called(struct vb2_queue *q)
+{
+	return q->start_streaming_called;
+}
+
 /*
  * The following functions are not part of the vb2 core API, but are simple
  * helper functions that you can use in your struct v4l2_file_operations,
-- 
1.9.1

