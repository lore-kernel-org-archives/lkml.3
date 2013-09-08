Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab3IHDUT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56140 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756957Ab3IHDSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:50 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "John W. Linville" <linville@tuxdriver.com>,
        "Stanislaw Gruszka" <sgruszka@redhat.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.699211671@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [054/121] iwl4965: set power mode early
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit eca396d7a5bdcc1fd67b1b12f737c213ac78a6f4 upstream.

If device was put into a sleep and system was restarted or module
reloaded, we have to wake device up before sending other commands.
Otherwise it will fail to start with Microcode error.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: adjust filename, context, naming]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlegacy/iwl4965-base.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -1764,6 +1764,9 @@ static void iwl4965_alive_start(struct i
 
 	priv->active_rate = IWL_RATES_MASK;
 
+	iwl_legacy_power_update_mode(priv, true);
+	IWL_DEBUG_INFO(priv, "Updated power mode\n");
+
 	if (iwl_legacy_is_associated_ctx(ctx)) {
 		struct iwl_legacy_rxon_cmd *active_rxon =
 				(struct iwl_legacy_rxon_cmd *)&ctx->active;
@@ -1796,9 +1799,6 @@ static void iwl4965_alive_start(struct i
 	IWL_DEBUG_INFO(priv, "ALIVE processing complete.\n");
 	wake_up(&priv->wait_command_queue);
 
-	iwl_legacy_power_update_mode(priv, true);
-	IWL_DEBUG_INFO(priv, "Updated power mode\n");
-
 	return;
 
  restart:

