Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967093AbaCUBWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:22:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36528 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760379AbaCUADi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.13 033/149] iwlwifi: dvm: clear IWL_STA_UCODE_INPROGRESS when assoc fails
Date: Thu, 20 Mar 2014 17:03:16 -0700
Message-Id: <20140321000438.110993510@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit ec6f678c74dbdb06a6a775bbb00f1d26c17c404b upstream.

We set IWL_STA_UCODE_INPROGRESS flag when we add a station
and clear it when we send the LQ command for it. But the LQ
command is sent only when the association succeeds.
If the association doesn't succeed, we would leave this flag
set and that wouldn't indicate the station entry as vacant.

This probably fixes:
https://bugzilla.redhat.com/show_bug.cgi?id=1065663

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/dvm/sta.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -590,6 +590,7 @@ void iwl_deactivate_station(struct iwl_p
 			sizeof(priv->tid_data[sta_id][tid]));
 
 	priv->stations[sta_id].used &= ~IWL_STA_DRIVER_ACTIVE;
+	priv->stations[sta_id].used &= ~IWL_STA_UCODE_INPROGRESS;
 
 	priv->num_stations--;
 


