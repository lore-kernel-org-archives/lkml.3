Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934391AbaJ2QJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:09:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45718 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933873AbaJ2QI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:08:58 -0400
Date: Wed, 29 Oct 2014 19:08:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] iwlwifi: cleanup a mask shift in iwlagn_bt_traffic_is_sco()
Message-ID: <20141029160827.GD5290@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The shift operation is higher precedence so the code is wrong and it
sets of a static checker warning.  But it doesn't affect real life
because BT_UART_MSG_FRAME3SCOESCO_POS is zero so the shift is a no-op.

I have re-written it in normal style and with parenthesis as a cleanup
and to silence the static checker warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/iwlwifi/dvm/lib.c b/drivers/net/wireless/iwlwifi/dvm/lib.c
index 2191621..065d3d5 100644
--- a/drivers/net/wireless/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
@@ -418,7 +418,7 @@ void iwlagn_bt_adjust_rssi_monitor(struct iwl_priv *priv, bool rssi_ena)
 
 static bool iwlagn_bt_traffic_is_sco(struct iwl_bt_uart_msg *uart_msg)
 {
-	return BT_UART_MSG_FRAME3SCOESCO_MSK & uart_msg->frame3 >>
+	return (uart_msg->frame3 & BT_UART_MSG_FRAME3SCOESCO_MSK) >>
 			BT_UART_MSG_FRAME3SCOESCO_POS;
 }
 
