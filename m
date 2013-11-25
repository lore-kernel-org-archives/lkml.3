Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab3KYTjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:39:35 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:17616 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756255Ab3KYTjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:39:32 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18+twjvEE9c39ONMM8fCeTU8Nsfmjy7sRM=
From: Jason Cooper <jason@lakedaemon.net>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: Jason Cooper <jason@lakedaemon.net>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] dma: mv_xor: remove mv_desc_get_dest_addr()
Date: Mon, 25 Nov 2013 19:39:25 +0000
Message-Id: <1385408365-8072-1-git-send-email-jason@lakedaemon.net>
X-Mailer: git-send-email 1.8.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit:

  54f8d501e842 dmaengine: remove DMA unmap from drivers

removed the last caller to mv_desc_get_dest_addr(), creating the
warning:

  drivers/dma/mv_xor.c:57:12: warning: 'mv_desc_get_dest_addr' defined
  but not used [-Wunused-function]

Remove it.

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/dma/mv_xor.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 7807f0ef4e20..23bcc9158cbc 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -54,12 +54,6 @@ static void mv_desc_init(struct mv_xor_desc_slot *desc, unsigned long flags)
 	hw_desc->desc_command = (1 << 31);
 }
 
-static u32 mv_desc_get_dest_addr(struct mv_xor_desc_slot *desc)
-{
-	struct mv_xor_desc *hw_desc = desc->hw_desc;
-	return hw_desc->phy_dest_addr;
-}
-
 static void mv_desc_set_byte_count(struct mv_xor_desc_slot *desc,
 				   u32 byte_count)
 {
-- 
1.8.4.4

