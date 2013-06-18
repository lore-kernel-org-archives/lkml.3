Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab3FRC1C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 22:27:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab3FRC07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 22:26:59 -0400
Date: Mon, 17 Jun 2013 22:26:52 -0400
Message-Id: <201306180226.r5I2Qq8x010834@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/7] sctp: Convert __list_for_each use to list_for_each
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@redhat.com>
---
 net/sctp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

netdev: patches 1-4 & 6 are independant to this, and 7 won't be
merged until this one gets to Linus' tree.

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index eaee00c..3b70b76 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -178,7 +178,7 @@ static void sctp_get_local_addr_list(struct net *net)
 
 	rcu_read_lock();
 	for_each_netdev_rcu(net, dev) {
-		__list_for_each(pos, &sctp_address_families) {
+		list_for_each(pos, &sctp_address_families) {
 			af = list_entry(pos, struct sctp_af, list);
 			af->copy_addrlist(&net->sctp.local_addr_list, dev);
 		}
-- 
1.8.1.4

