Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab3ICQYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:24:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46446 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab3ICQYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:24:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 04/58] iwl4965: set power mode early
Date: Tue,  3 Sep 2013 09:23:08 -0700
Message-Id: <1378225442-20654-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit eca396d7a5bdcc1fd67b1b12f737c213ac78a6f4 upstream.

If device was put into a sleep and system was restarted or module
reloaded, we have to wake device up before sending other commands.
Otherwise it will fail to start with Microcode error.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index c3fbf67..c640f69 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5287,6 +5287,9 @@ il4965_alive_start(struct il_priv *il)
 
 	il->active_rate = RATES_MASK;
 
+	il_power_update_mode(il, true);
+	D_INFO("Updated power mode\n");
+
 	if (il_is_associated(il)) {
 		struct il_rxon_cmd *active_rxon =
 		    (struct il_rxon_cmd *)&il->active;
@@ -5317,9 +5320,6 @@ il4965_alive_start(struct il_priv *il)
 	D_INFO("ALIVE processing complete.\n");
 	wake_up(&il->wait_command_queue);
 
-	il_power_update_mode(il, true);
-	D_INFO("Updated power mode\n");
-
 	return;
 
 restart:
-- 
1.8.1.2

