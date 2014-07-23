Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbaGWGQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:16:43 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36184 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaGWGQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:16:42 -0400
From: Robin Schroer <sulamiification@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH -next] staging/goldfish/goldfish_audio: fix a sparse warning
Date: Wed, 23 Jul 2014 08:16:39 +0200
Message-Id: <1406096199-12016-1-git-send-email-sulamiification@gmail.com>
X-Mailer: git-send-email 2.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a pointer check to use NULL instead of 0

Warning:
drivers/staging/goldfish/goldfish_audio.c:300:34: warning: Using plain
integer as NULL pointer

Signed-off-by: Robin Schroer <sulamiification@gmail.com>
---
 drivers/staging/goldfish/goldfish_audio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/goldfish/goldfish_audio.c b/drivers/staging/goldfish/goldfish_audio.c
index 9df4ad8..c89d0b8 100644
--- a/drivers/staging/goldfish/goldfish_audio.c
+++ b/drivers/staging/goldfish/goldfish_audio.c
@@ -297,7 +297,7 @@ static int goldfish_audio_probe(struct platform_device *pdev)
 	}
 	data->buffer_virt = dmam_alloc_coherent(&pdev->dev,
 				COMBINED_BUFFER_SIZE, &buf_addr, GFP_KERNEL);
-	if (data->buffer_virt == 0) {
+	if (data->buffer_virt == NULL) {
 		dev_err(&pdev->dev, "allocate buffer failed\n");
 		return -ENOMEM;
 	}
-- 
2.0.2

