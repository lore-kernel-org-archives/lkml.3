Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbaHHWYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:24:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40389 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaHHUqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:46:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Suresh Reddy <Suresh.Reddy@emulex.com>,
        Sathya Perla <sathya.perla@emulex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 251/259] be2net: set EQ DB clear-intr bit in be_open()
Date: Fri,  8 Aug 2014 13:41:14 -0700
Message-Id: <1407530482-4483-252-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suresh Reddy <Suresh.Reddy@emulex.com>

[ Upstream commit 4cad9f3b61c7268fa89ab8096e23202300399b5d ]

On BE3, if the clear-interrupt bit of the EQ doorbell is not set the first
time it is armed, ocassionally we have observed that the EQ doesn't raise
anymore interrupts even if it is in armed state.
This patch fixes this by setting the clear-interrupt bit when EQs are
armed for the first time in be_open().

Signed-off-by: Suresh Reddy <Suresh.Reddy@emulex.com>
Signed-off-by: Sathya Perla <sathya.perla@emulex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index a37039d..a67ddf8 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -2797,7 +2797,7 @@ static int be_open(struct net_device *netdev)
 	for_all_evt_queues(adapter, eqo, i) {
 		napi_enable(&eqo->napi);
 		be_enable_busy_poll(eqo);
-		be_eq_notify(adapter, eqo->q.id, true, false, 0);
+		be_eq_notify(adapter, eqo->q.id, true, true, 0);
 	}
 	adapter->flags |= BE_FLAGS_NAPI_ENABLED;
 
-- 
1.9.1

