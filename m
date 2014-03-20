Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965019AbaCTOqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:46:05 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51672 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933240AbaCTOqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:46:00 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eddie.wai@broadcom.com,
        paulmck@linux.vnet.ibm.com
Subject: [PATCH 7/9] target: Replace rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL) in drivers/target/tcm_fc/tfc_sess.c
Date: Thu, 20 Mar 2014 20:15:06 +0530
Message-Id: <db3a67a00fa847aabde7244268fafdbc78783207.1395324808.git.monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <53f52b8b185a76418272b3ad78dc566a3163a7e0.1395324808.git.monamagarwal123@gmail.com>
References: <53f52b8b185a76418272b3ad78dc566a3163a7e0.1395324808.git.monamagarwal123@gmail.com>
In-Reply-To: <cover.1395324808.git.monamagarwal123@gmail.com>
References: <cover.1395324808.git.monamagarwal123@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/target/tcm_fc/tfc_sess.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 3269213..95fb826 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -110,7 +110,7 @@ static void ft_tport_delete(struct ft_tport *tport)
 	ft_sess_delete_all(tport);
 	lport = tport->lport;
 	BUG_ON(tport != lport->prov[FC_TYPE_FCP]);
-	rcu_assign_pointer(lport->prov[FC_TYPE_FCP], NULL);
+	RCU_INIT_POINTER(lport->prov[FC_TYPE_FCP], NULL);
 
 	tpg = tport->tpg;
 	if (tpg) {
-- 
1.7.9.5

