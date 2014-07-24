Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935025AbaGXXHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:07:50 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42438 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934949AbaGXXHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:07:11 -0400
X-Originating-IP: 109.10.215.15
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 14/14] staging: vt6655: Remove NULL pointer sparse warning
Date: Fri, 25 Jul 2014 01:06:28 +0200
Message-Id: <1406243188-13413-15-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406243188-13413-1-git-send-email-gclement@baobob.org>
References: <1406243188-13413-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were using 0 instead of NULL to initialize a pointer, which caused
a sparse warning.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/device_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 33a25bc..3e18987 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1610,7 +1610,7 @@ static void device_free_tx_buf(PSDevice pDevice, PSTxDesc pDesc)
 		dev_kfree_skb_irq(skb);
 
 	pTDInfo->skb_dma = 0;
-	pTDInfo->skb = 0;
+	pTDInfo->skb = NULL;
 	pTDInfo->byFlags = 0;
 }
 
-- 
1.8.5.5

