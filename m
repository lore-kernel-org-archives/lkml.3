Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab3I3Kdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:33:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43473 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab3I3KMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 030/104] iwlwifi: dvm: don't send BT_CONFIG on devices w/o Bluetooth
Date: Mon, 30 Sep 2013 11:10:07 +0100
Message-Id: <1380535881-9239-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 707aee401d2467baa785a697f40a6e2d9ee79ad5 upstream.

The BT_CONFIG command that is sent to the device during
startup will enable BT coex unless the module parameter
turns it off, but on devices without Bluetooth this may
cause problems, as reported in Redhat BZ 885407.

Fix this by sending the BT_CONFIG command only when the
device has Bluetooth.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
[ luis: backported to 3.5 (based on bwh's backport to 3.2):
  - file rename: drivers/net/wireless/iwlwifi/dvm/main.c ->
    drivers/net/wireless/iwlwifi/iwl-agn.c
  - use priv->cfg instead of priv->lib ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ec36e2b..8e3629a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -799,7 +799,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 					 BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
 		if (ret)
 			return ret;
-	} else {
+	} else if (priv->cfg->bt_params) {
 		/*
 		 * default is 2-wire BT coexexistence support
 		 */
-- 
1.8.3.2

