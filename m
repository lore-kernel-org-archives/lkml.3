Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaETQhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:37:31 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:14829 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696AbaETQh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:37:29 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtYWAEGEe1NbsnsG/2dsb2JhbABZgwaCRKhEBAEBAQEBAQUBgzqWbgICgRwXdIJTEz8YgQIkE4hFAdQbhVWIeYRHAQOPPIorAYsSiA6DOjsw
Date: Tue, 20 May 2014 18:37:28 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] drivers/s390/cio/qdio_main.c: replace shift loop by
 ilog2
Message-Id: <20140520183728.c28374c3f1a655a2e33996a3@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is untested.

Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/s390/cio/qdio_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 77466c4..8bf9ec1 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -411,15 +411,14 @@ static inline void qdio_stop_polling(struct qdio_q *q)
 
 static inline void account_sbals(struct qdio_q *q, int count)
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
