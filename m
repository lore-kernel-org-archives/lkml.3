Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab3HBUK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 16:10:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48775 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752896Ab3HBUKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 16:10:55 -0400
Message-ID: <1375474254.2034.134.camel@joe-AO722>
Subject: [PATCH] pktcdvd: Fix defective misuses of pkt_<level>
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kernel-janitors@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 02 Aug 2013 13:10:54 -0700
In-Reply-To: <20130801154452.GB5198@elgon.mountain>
References: <20130801154452.GB5198@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix thinkos where pkt_<level> needs a valid
pktcdvd_device * and the pointer is known to
be NULL.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com> (go smatch!)
Signed-off-by: Joe Perches <joe@perches.com>
---

Andrew, I believe Jiri picked up this series and
you can drop them from mm.  Thanks.

 drivers/block/pktcdvd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 29a5194..5618847 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2360,8 +2360,8 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 
 	pd = q->queuedata;
 	if (!pd) {
-		pkt_err(pd, "%s incorrect request queue\n",
-			bdevname(bio->bi_bdev, b));
+		pr_err("%s incorrect request queue\n",
+		       bdevname(bio->bi_bdev, b));
 		goto end_io;
 	}
 
@@ -2841,7 +2841,7 @@ static int pkt_remove_dev(dev_t pkt_dev)
 			break;
 	}
 	if (idx == MAX_WRITERS) {
-		pkt_dbg(1, pd, "dev not setup\n");
+		pr_debug("dev not setup\n");
 		ret = -ENXIO;
 		goto out;
 	}


