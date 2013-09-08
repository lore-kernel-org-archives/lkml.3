Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320Ab3IHDUJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56129 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756089Ab3IHDSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:47 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johannes Berg" <johannes@sipsolutions.net>,
        "Johannes Berg" <johannes.berg@intel.com>,
        "Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.555847976@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [027/121] iwlwifi: dvm: don't send BT_CONFIG on devices w/o Bluetooth
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust filename
 - s/priv->lib/priv->cfg/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1297,7 +1297,7 @@ int iwl_alive_start(struct iwl_priv *pri
 					 BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
 		if (ret)
 			return ret;
-	} else {
+	} else if (priv->cfg->bt_params) {
 		/*
 		 * default is 2-wire BT coexexistence support
 		 */

