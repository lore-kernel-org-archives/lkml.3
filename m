Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab3IKE65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab3IKE5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:03 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=5ZvH8dDEkUoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=opWlHiBTqogA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=jEp0ucaQiEUA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042924.783937190@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [196/251] iwl4965: set power mode early
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0196-iwl4965-set-power-mode-early.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

[ Upstream commit eca396d7a5bdcc1fd67b1b12f737c213ac78a6f4 ]

If device was put into a sleep and system was restarted or module
reloaded, we have to wake device up before sending other commands.
Otherwise it will fail to start with Microcode error.

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 34f61a0..ab56f92 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5285,6 +5285,9 @@ il4965_alive_start(struct il_priv *il)
 
 	il->active_rate = RATES_MASK;
 
+	il_power_update_mode(il, true);
+	D_INFO("Updated power mode\n");
+
 	if (il_is_associated(il)) {
 		struct il_rxon_cmd *active_rxon =
 		    (struct il_rxon_cmd *)&il->active;
@@ -5315,9 +5318,6 @@ il4965_alive_start(struct il_priv *il)
 	D_INFO("ALIVE processing complete.\n");
 	wake_up(&il->wait_command_queue);
 
-	il_power_update_mode(il, true);
-	D_INFO("Updated power mode\n");
-
 	return;
 
 restart:
-- 
1.7.10.4


