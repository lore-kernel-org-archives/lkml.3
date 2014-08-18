Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbaHRJ6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:58:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42688 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbaHRJek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:34:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Suresh Reddy <Suresh.Reddy@emulex.com>,
        Sathya Perla <sathya.perla@emulex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 052/137] be2net: set EQ DB clear-intr bit in be_open()
Date: Mon, 18 Aug 2014 10:31:53 +0100
Message-Id: <1408354398-10226-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suresh Reddy <Suresh.Reddy@emulex.com>

commit 4cad9f3b61c7268fa89ab8096e23202300399b5d upstream.

On BE3, if the clear-interrupt bit of the EQ doorbell is not set the first
time it is armed, ocassionally we have observed that the EQ doesn't raise
anymore interrupts even if it is in armed state.
This patch fixes this by setting the clear-interrupt bit when EQs are
armed for the first time in be_open().

Signed-off-by: Suresh Reddy <Suresh.Reddy@emulex.com>
Signed-off-by: Sathya Perla <sathya.perla@emulex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 3d91a5ec61a4..8dee3d9835dd 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -2665,7 +2665,7 @@ static int be_open(struct net_device *netdev)
 
 	for_all_evt_queues(adapter, eqo, i) {
 		napi_enable(&eqo->napi);
-		be_eq_notify(adapter, eqo->q.id, true, false, 0);
+		be_eq_notify(adapter, eqo->q.id, true, true, 0);
 	}
 	adapter->flags |= BE_FLAGS_NAPI_ENABLED;
 
-- 
1.9.1

