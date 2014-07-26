Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbaGZTxL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:53:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbaGZTNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Suresh Reddy <Suresh.Reddy@emulex.com>,
        Sathya Perla <sathya.perla@emulex.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 54/87] be2net: set EQ DB clear-intr bit in be_open()
Date: Sat, 26 Jul 2014 12:02:28 -0700
Message-Id: <20140726190216.370056048@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/emulex/benet/be_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -2797,7 +2797,7 @@ static int be_open(struct net_device *ne
 	for_all_evt_queues(adapter, eqo, i) {
 		napi_enable(&eqo->napi);
 		be_enable_busy_poll(eqo);
-		be_eq_notify(adapter, eqo->q.id, true, false, 0);
+		be_eq_notify(adapter, eqo->q.id, true, true, 0);
 	}
 	adapter->flags |= BE_FLAGS_NAPI_ENABLED;
 


