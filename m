Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaKRLYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:24:18 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:46170 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbaKRLYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:24:14 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 11/12] media: davinci: vpif_capture: use vb2_ops_wait_prepare/finish helper
Date: Tue, 18 Nov 2014 11:23:40 +0000
Message-Id: <1416309821-5426-12-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 3ccb26f..d8e1b98 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -311,6 +311,8 @@ static struct vb2_ops video_qops = {
 	.start_streaming	= vpif_start_streaming,
 	.stop_streaming		= vpif_stop_streaming,
 	.buf_queue		= vpif_buffer_queue,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 };
 
 /**
-- 
1.9.1

