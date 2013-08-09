Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030321Ab3HIB7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:59:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030217Ab3HIB7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [ 102/102] iwlwifi: dvm: dont send BT_CONFIG on devices w/o Bluetooth
Date: Thu,  8 Aug 2013 18:58:18 -0700
Message-Id: <20130809015034.304075191@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/net/wireless/iwlwifi/dvm/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -758,7 +758,7 @@ int iwl_alive_start(struct iwl_priv *pri
 					 BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
 		if (ret)
 			return ret;
-	} else {
+	} else if (priv->cfg->bt_params) {
 		/*
 		 * default is 2-wire BT coexexistence support
 		 */


