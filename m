Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbaETQjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:39:06 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:41702 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704AbaETQjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:39:05 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtYWAFWDe1NbsnsG/2dsb2JhbABZgwaCRKhDBAEBAQEBAQUBgzqWbgICgRwXdIJTEz8YgQIkE4hFAdQihVWIeYRHAQOPPIorAYsSiA6DOjs
Date: Tue, 20 May 2014 18:39:03 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Eddie Wai <eddie.wai@broadcom.com>, akpm <akpm@linux-foundation.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH 1/1] drivers/scsi/bnx2i/bnx2i_iscsi.c: replace shift loop by
 ilog2
Message-Id: <20140520183903.fc7912a16fd0a05b0b9b26a0@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Eddie Wai <eddie.wai@broadcom.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 166543f..8ea1360 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -397,9 +397,7 @@ static struct iscsi_endpoint *bnx2i_alloc_ep(struct bnx2i_hba *hba)
 	bnx2i_ep->hba_age = hba->age;
 
 	ec_div = event_coal_div;
-	while (ec_div >>= 1)
-		bnx2i_ep->ec_shift += 1;
-
+	bnx2i_ep->ec_shift += ilog2(ec_div);
 	hba->ofld_conns_active++;
 	init_waitqueue_head(&bnx2i_ep->ofld_wait);
 	return ep;
-- 
1.8.4.5

