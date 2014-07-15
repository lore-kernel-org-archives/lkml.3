Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaGONrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:47:46 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:33308 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaGONro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:47:44 -0400
X-IronPort-AV: E=Sophos;i="5.01,665,1400025600"; 
   d="scan'208,146";a="152988138"
Message-ID: <1405432057.1749.4.camel@hamster.uk.xensource.com>
Subject: xen: Remove useless cast
From: Frediano Ziglio <frediano.ziglio@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: xen-devel <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Date: Tue, 15 Jul 2014 14:47:37 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BM macro just do a cast to long*. This cast was required to avoid a
warning as ready was unsigned int instead of long.
As now the variable is already a long the cast is not needed.

Signed-off-by: Frediano Ziglio <frediano.ziglio@citrix.com>
---
 drivers/xen/events/events_fifo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/events/events_fifo.c b/drivers/xen/events/events_fifo.c
index 84b4bfb..d302639 100644
--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -312,7 +312,7 @@ static void evtchn_fifo_handle_events(unsigned cpu)
 	ready = xchg(&control_block->ready, 0);
 
 	while (ready) {
-		q = find_first_bit(BM(&ready), EVTCHN_FIFO_MAX_QUEUES);
+		q = find_first_bit(&ready, EVTCHN_FIFO_MAX_QUEUES);
 		consume_one_event(cpu, control_block, q, &ready);
 		ready |= xchg(&control_block->ready, 0);
 	}
-- 
1.9.1


