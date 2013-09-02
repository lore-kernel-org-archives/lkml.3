Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab3IBIzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:55:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37658 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758297Ab3IBIy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:54:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 07/58] iwl4965: set power mode early
Date: Mon,  2 Sep 2013 09:53:52 +0100
Message-Id: <1378112083-9475-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit eca396d7a5bdcc1fd67b1b12f737c213ac78a6f4 upstream.

If device was put into a sleep and system was restarted or module
reloaded, we have to wake device up before sending other commands.
Otherwise it will fail to start with Microcode error.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index ff5d689..b7528ef 100644
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
1.8.3.2

