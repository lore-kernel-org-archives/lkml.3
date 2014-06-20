Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966535AbaFTJF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:05:59 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33641 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965860AbaFTJF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:05:56 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, andreas.noever@gmail.com, spk.linux@gmail.com
Subject: [PATCH 5/6] thunderbolt: Use NULL instead of 0 in nhi.c
Date: Fri, 20 Jun 2014 14:32:33 +0530
Message-Id: <1403254954-14429-5-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403254954-14429-1-git-send-email-sachin.kamat@samsung.com>
References: <1403254954-14429-1-git-send-email-sachin.kamat@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'descriptors' is a pointer. Use NULL isntead of 0.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
 drivers/thunderbolt/nhi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index 346b41e7d5d1..0fc137af89f5 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -416,7 +416,7 @@ void ring_free(struct tb_ring *ring)
 			  ring->size * sizeof(*ring->descriptors),
 			  ring->descriptors, ring->descriptors_dma);
 
-	ring->descriptors = 0;
+	ring->descriptors = NULL;
 	ring->descriptors_dma = 0;
 
 
-- 
1.7.9.5

