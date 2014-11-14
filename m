Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161876AbaKNUeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:34:46 -0500
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:59390 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161839AbaKNUep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:34:45 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4SAJBmZlRXQzQ2/2dsb2JhbABbgw6BLrlDBQF1mg8EAoEeFwEBAQEBfYQwLyOBGjeIRQHBfJAmLIY+imQdhDUFnkyWeoFHAYI1PDCCSwEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/1 linux-next] ARM: edma: remove unnecessary sizeof(s8)
Date: Fri, 14 Nov 2014 21:34:37 +0100
Message-Id: <1415997277-4521-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof(s8) is always 1

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/arm/common/edma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 72041f0..d6659fd 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1486,8 +1486,7 @@ static int edma_setup_from_hw(struct device *dev, struct edma_soc_info *pdata,
 	 * priority. So Q0 is the highest priority queue and the last queue has
 	 * the lowest priority.
 	 */
-	queue_priority_map = devm_kzalloc(dev,
-					  (edma_cc->num_tc + 1) * sizeof(s8),
+	queue_priority_map = devm_kzalloc(dev, edma_cc->num_tc + 1,
 					  GFP_KERNEL);
 	if (!queue_priority_map)
 		return -ENOMEM;
-- 
1.9.3

