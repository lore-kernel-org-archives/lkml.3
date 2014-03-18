Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241AbaCRWqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 18:46:38 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49363 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941AbaCRWqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 18:46:36 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eddie.wai@broadcom.com,
        paulmck@linux.vnet.ibm.com
Subject: [PATCH 4/9] rcu: Replace rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)
Date: Wed, 19 Mar 2014 04:15:44 +0530
Message-Id: <dfae0194a7fa12d09826ec79bbd7cecd132c7f8d.1395182132.git.monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <a526cbfdba8a9a3380b685d34b4ee7ce52163d57.1395182132.git.monamagarwal123@gmail.com>
References: <a526cbfdba8a9a3380b685d34b4ee7ce52163d57.1395182132.git.monamagarwal123@gmail.com>
In-Reply-To: <cover.1395182132.git.monamagarwal123@gmail.com>
References: <cover.1395182132.git.monamagarwal123@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/net/ppp/pptp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index 89f829f..ede899c 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -162,7 +162,7 @@ static void del_chan(struct pppox_sock *sock)
 {
 	spin_lock(&chan_lock);
 	clear_bit(sock->proto.pptp.src_addr.call_id, callid_bitmap);
-	rcu_assign_pointer(callid_sock[sock->proto.pptp.src_addr.call_id], NULL);
+	RCU_INIT_POINTER(callid_sock[sock->proto.pptp.src_addr.call_id], NULL);
 	spin_unlock(&chan_lock);
 	synchronize_rcu();
 }
-- 
1.7.9.5

