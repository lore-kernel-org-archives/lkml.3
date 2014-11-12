Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaKLBUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:20:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbaKLBUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:20:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anish Bhatt <anish@chelsio.com>, Casey Leedom <leedom@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 018/319] cxgb4 : Fix missing initialization of win0_lock
Date: Wed, 12 Nov 2014 10:12:36 +0900
Message-Id: <20141112010955.679102933@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anish Bhatt <anish@chelsio.com>

[ Upstream commit e327c225c911529898ec300cb96d2088893de3df ]

win0_lock was being used un-initialized, resulting in warning traces
being seen when lock debugging is enabled (and just wrong)

Fixes : fc5ab0209650 ('cxgb4: Replaced the backdoor mechanism to access the HW
 memory with PCIe Window method')

Signed-off-by: Anish Bhatt <anish@chelsio.com>
Signed-off-by: Casey Leedom <leedom@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6557,6 +6557,7 @@ static int init_one(struct pci_dev *pdev
 
 	spin_lock_init(&adapter->stats_lock);
 	spin_lock_init(&adapter->tid_release_lock);
+	spin_lock_init(&adapter->win0_lock);
 
 	INIT_WORK(&adapter->tid_release_task, process_tid_release_list);
 	INIT_WORK(&adapter->db_full_task, process_db_full);


