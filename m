Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab3CDDmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:42:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60727 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755220Ab3CDDm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:27 -0500
Message-Id: <20130304033707.792446514@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:08 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        Mark Kettenis <mark.kettenis@xs4all.nl>
Subject: [ 001/153] sunvdc: Fix off-by-one in generic_request().
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit f4d9605434c0fd4cc8639bf25cfc043418c52362 ]

The 'operations' bitmap corresponds one-for-one with the operation
codes, no adjustment is necessary.

Reported-by: Mark Kettenis <mark.kettenis@xs4all.nl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/sunvdc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -461,7 +461,7 @@ static int generic_request(struct vdc_po
 	int op_len, err;
 	void *req_buf;
 
-	if (!(((u64)1 << ((u64)op - 1)) & port->operations))
+	if (!(((u64)1 << (u64)op) & port->operations))
 		return -EOPNOTSUPP;
 
 	switch (op) {


