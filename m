Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab3HWRes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:34:48 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:48521 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab3HWReq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:34:46 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 5/6] staging: ozwpan: Fix error checking while transmitting frame.
Date: Fri, 23 Aug 2013 18:33:32 +0100
Message-ID: <1377279213-17074-5-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377279213-17074-1-git-send-email-rupesh.gujare@atmel.com>
References: <1377279213-17074-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that we return negative value if oz_build_frame()
returns NULL.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozpd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index daaff2a..e1757aa 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -618,14 +618,14 @@ static int oz_send_next_queued_frame(struct oz_pd *pd, int more_data)
 	pd->last_sent_frame = e;
 	skb = oz_build_frame(pd, f);
 	spin_unlock(&pd->tx_frame_lock);
+	if (!skb)
+		return -1;
 	if (more_data)
 		oz_set_more_bit(skb);
 	oz_dbg(TX_FRAMES, "TX frame PN=0x%x\n", f->hdr.pkt_num);
-	if (skb) {
-		if (dev_queue_xmit(skb) < 0)
-			return -1;
+	if (dev_queue_xmit(skb) < 0)
+		return -1;
 
-	}
 	return 0;
 }
 
-- 
1.7.9.5

