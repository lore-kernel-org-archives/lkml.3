Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409AbaFCT4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:56:30 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:13373 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754430AbaFCT42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:56:28 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnsOAJwnjlNbsmtf/2dsb2JhbABZgweBJ6o3BAMBAQEFAZgcgQ4XdIJTLyOBGjeIRgHRJBeFVYh9HYQqBI9Lij+LHYgWgzo7Lw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH V2 2/2] drivers/s390/cio/qdio_main.c: replace shift loop by ilog2
Date: Tue,  3 Jun 2014 21:55:15 +0200
Message-Id: <1401825315-5845-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

account_sbals is called by get_inbound_buffer_frontier and
get_outbound_buffer_frontier with 'count' value > 0 so we can safely convert
shift loop to ilog2.

Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/s390/cio/qdio_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 9fda160..2eee7f1 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -413,15 +413,14 @@ static inline void qdio_stop_polling(struct qdio_q *q)
 
 static inline void account_sbals(struct qdio_q *q, unsigned int count)
 {
-	int pos = 0;
+	int pos;
 
 	q->q_stats.nr_sbal_total += count;
 	if (count == QDIO_MAX_BUFFERS_MASK) {
 		q->q_stats.nr_sbals[7]++;
 		return;
 	}
-	while (count >>= 1)
-		pos++;
+	pos = ilog2(count);
 	q->q_stats.nr_sbals[pos]++;
 }
 
-- 
1.8.4.5

