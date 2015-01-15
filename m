Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbbAOK23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:28:29 -0500
Received: from mga14.intel.com ([192.55.52.115]:26482 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbbAOK21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:28:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,402,1418112000"; 
   d="scan'208";a="512633633"
From: Anda-Maria Nicolae <anda-maria.nicolae@intel.com>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, christophe.ricard@gmail.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] NFC: st21nfcb: Avoid use of skb after free
Date: Thu, 15 Jan 2015 12:30:57 +0200
Message-Id: <1421317857-1713-1-git-send-email-anda-maria.nicolae@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not insert in send queue the skb that contains unknown Packet Control Byte

Signed-off-by: Anda-Maria Nicolae <anda-maria.nicolae@intel.com>
---
Only compile tested, please have a look

 drivers/nfc/st21nfcb/ndlc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/st21nfcb/ndlc.c b/drivers/nfc/st21nfcb/ndlc.c
index bac50e8..72659a3 100644
--- a/drivers/nfc/st21nfcb/ndlc.c
+++ b/drivers/nfc/st21nfcb/ndlc.c
@@ -138,7 +138,7 @@ static void llt_ndlc_requeue_data_pending(struct llt_ndlc *ndlc)
 		default:
 			pr_err("UNKNOWN Packet Control Byte=%d\n", pcb);
 			kfree_skb(skb);
-			break;
+			continue;
 		}
 		skb_queue_head(&ndlc->send_q, skb);
 	}
-- 
1.7.9.5

