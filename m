Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaLZOqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:46:45 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:4736 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008AbaLZOme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:42:34 -0500
X-IronPort-AV: E=Sophos;i="5.07,647,1413237600"; 
   d="scan'208";a="114895462"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Johannes Berg <johannes.berg@intel.com>
Cc: kernel-janitors@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/27] iwlwifi: dvm: tt: Use setup_timer
Date: Fri, 26 Dec 2014 15:35:43 +0100
Message-Id: <1419604558-29743-13-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1419604558-29743-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1419604558-29743-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert a call to init_timer and accompanying intializations of
the timer's data and function fields to a call to setup_timer.

A simplified version of the semantic match that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression t,f,d;
@@

-init_timer(&t);
+setup_timer(&t,f,d);
-t.data = d;
-t.function = f;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/wireless/iwlwifi/dvm/tt.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/tt.c b/drivers/net/wireless/iwlwifi/dvm/tt.c
index acb981a..c4736c8 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tt.c
@@ -612,15 +612,10 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 	memset(tt, 0, sizeof(struct iwl_tt_mgmt));
 
 	tt->state = IWL_TI_0;
-	init_timer(&priv->thermal_throttle.ct_kill_exit_tm);
-	priv->thermal_throttle.ct_kill_exit_tm.data = (unsigned long)priv;
-	priv->thermal_throttle.ct_kill_exit_tm.function =
-		iwl_tt_check_exit_ct_kill;
-	init_timer(&priv->thermal_throttle.ct_kill_waiting_tm);
-	priv->thermal_throttle.ct_kill_waiting_tm.data =
-		(unsigned long)priv;
-	priv->thermal_throttle.ct_kill_waiting_tm.function =
-		iwl_tt_ready_for_ct_kill;
+	setup_timer(&priv->thermal_throttle.ct_kill_exit_tm,
+		    iwl_tt_check_exit_ct_kill, (unsigned long)priv);
+	setup_timer(&priv->thermal_throttle.ct_kill_waiting_tm,
+		    iwl_tt_ready_for_ct_kill, (unsigned long)priv);
 	/* setup deferred ct kill work */
 	INIT_WORK(&priv->tt_work, iwl_bg_tt_work);
 	INIT_WORK(&priv->ct_enter, iwl_bg_ct_enter);

