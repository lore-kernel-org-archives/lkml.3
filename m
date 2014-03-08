Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbaCHBJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:09:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbaCHBIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:08:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Ben Hutchings <ben@decadent.org.uk>, Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 94/99] iwlwifi: dvm: dont send BT_CONFIG on devices w/o Bluetooth
Date: Fri,  7 Mar 2014 17:08:30 -0800
Message-Id: <20140308010614.574314708@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[wujg: Backported to 3.4:
 - s/priv->cfg/priv->shrd->cfg/]
Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -680,7 +680,7 @@ int iwl_alive_start(struct iwl_priv *pri
 					 BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
 		if (ret)
 			return ret;
-	} else {
+	} else if (priv->shrd->cfg->bt_params) {
 		/*
 		 * default is 2-wire BT coexexistence support
 		 */


