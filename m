Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab3FDXE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:04:29 -0400
Received: from 1wt.eu ([62.212.114.60]:35612 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab3FDWm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:56 -0400
Message-Id: <20130604172136.477809906@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:59 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Hillf Danton <dhillf@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 149/184] bonding: Fix slave selection bug.
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Hillf Danton <dhillf@gmail.com>

The returned slave is incorrect, if the net device under check is not
charged yet by the master.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit af3e5bd5f650163c2e12297f572910a1af1b8236)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/bonding/bonding.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bonding.h b/drivers/net/bonding/bonding.h
index 6824771..5d127fc 100644
--- a/drivers/net/bonding/bonding.h
+++ b/drivers/net/bonding/bonding.h
@@ -236,11 +236,11 @@ static inline struct slave *bond_get_slave_by_dev(struct bonding *bond, struct n
 
 	bond_for_each_slave(bond, slave, i) {
 		if (slave->dev == slave_dev) {
-			break;
+			return slave;
 		}
 	}
 
-	return slave;
+	return 0;
 }
 
 static inline struct bonding *bond_get_bond_by_slave(struct slave *slave)
-- 
1.7.12.2.21.g234cd45.dirty



