Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaHRMFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:05:53 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:54398 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaHRMFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:05:51 -0400
Date: Mon, 18 Aug 2014 15:05:37 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: nab@linux-iscsi.org, agrover@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] tcm_fc: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
Message-ID: <20140818120537.GA19578@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of "rcu_assign_pointer()" is NULLing out the pointer.
According to RCU_INIT_POINTER()'s block comment:
"1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 drivers/target/tcm_fc/tfc_sess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 21ce508..ccee7e3 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -98,7 +98,7 @@ static void ft_tport_delete(struct ft_tport *tport)
 	ft_sess_delete_all(tport);
 	lport = tport->lport;
 	BUG_ON(tport != lport->prov[FC_TYPE_FCP]);
-	rcu_assign_pointer(lport->prov[FC_TYPE_FCP], NULL);
+	RCU_INIT_POINTER(lport->prov[FC_TYPE_FCP], NULL);
 
 	tpg = tport->tpg;
 	if (tpg) {
-- 
1.9.1

