Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaHMJUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:20:54 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:62748 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaHMJUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:20:52 -0400
Date: Wed, 13 Aug 2014 14:50:47 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Mike Marciniszyn <infinipath@intel.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] IB/qib: Drop unnecessary continue
Message-ID: <20140813092047.GA3150@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Continue is not needed at the bottom of a loop.

The Coccinelle semantic patch implementing this change is:

@@
@@

for (...;...;...) {
  ...
  if (...) {
    ...
-   continue;
  }
}

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/infiniband/hw/qib/qib_init.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 8d3c78d..3bee93a4 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -705,11 +705,9 @@ int qib_init(struct qib_devdata *dd, int reinit)
 		lastfail = qib_create_rcvhdrq(dd, rcd);
 		if (!lastfail)
 			lastfail = qib_setup_eagerbufs(rcd);
-		if (lastfail) {
+		if (lastfail)
 			qib_dev_err(dd,
 				"failed to allocate kernel ctxt's rcvhdrq and/or egr bufs\n");
-			continue;
-		}
 	}
 
 	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
-- 
1.9.1

