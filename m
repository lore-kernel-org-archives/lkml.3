Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaLZOmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:42:54 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17526 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983AbaLZOmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:42:33 -0500
X-IronPort-AV: E=Sophos;i="5.07,647,1413237600"; 
   d="scan'208";a="114895463"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Johannes Berg <johannes.berg@intel.com>
Cc: kernel-janitors@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/27] iwlwifi: dvm: main: Use setup_timer
Date: Fri, 26 Dec 2014 15:35:44 +0100
Message-Id: <1419604558-29743-14-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/net/wireless/iwlwifi/dvm/main.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 0b7f46f..75ec691 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1011,13 +1011,11 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	if (priv->lib->bt_params)
 		iwlagn_bt_setup_deferred_work(priv);
 
-	init_timer(&priv->statistics_periodic);
-	priv->statistics_periodic.data = (unsigned long)priv;
-	priv->statistics_periodic.function = iwl_bg_statistics_periodic;
+	setup_timer(&priv->statistics_periodic, iwl_bg_statistics_periodic,
+		    (unsigned long)priv);
 
-	init_timer(&priv->ucode_trace);
-	priv->ucode_trace.data = (unsigned long)priv;
-	priv->ucode_trace.function = iwl_bg_ucode_trace;
+	setup_timer(&priv->ucode_trace, iwl_bg_ucode_trace,
+		    (unsigned long)priv);
 }
 
 void iwl_cancel_deferred_work(struct iwl_priv *priv)

