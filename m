Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaG3MYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:24:50 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36777 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753008AbaG3MPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Suresh Reddy <Suresh.Reddy@emulex.com>,
        Sathya Perla <sathya.perla@emulex.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 51/94] be2net: set EQ DB clear-intr bit in be_open()
Date: Wed, 30 Jul 2014 14:14:40 +0200
Message-Id: <a67b16e232f5ff624d4f600842ab56c752a0397a.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Reddy <Suresh.Reddy@emulex.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 4cad9f3b61c7268fa89ab8096e23202300399b5d ]

On BE3, if the clear-interrupt bit of the EQ doorbell is not set the first
time it is armed, ocassionally we have observed that the EQ doesn't raise
anymore interrupts even if it is in armed state.
This patch fixes this by setting the clear-interrupt bit when EQs are
armed for the first time in be_open().

Signed-off-by: Suresh Reddy <Suresh.Reddy@emulex.com>
Signed-off-by: Sathya Perla <sathya.perla@emulex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 2c38cc402119..5226c99813c7 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -2632,7 +2632,7 @@ static int be_open(struct net_device *netdev)
 
 	for_all_evt_queues(adapter, eqo, i) {
 		napi_enable(&eqo->napi);
-		be_eq_notify(adapter, eqo->q.id, true, false, 0);
+		be_eq_notify(adapter, eqo->q.id, true, true, 0);
 	}
 	adapter->flags |= BE_FLAGS_NAPI_ENABLED;
 
-- 
2.0.1

