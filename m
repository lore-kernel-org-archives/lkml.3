Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967531Ab3HIB6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:58:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55673 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967383Ab3HIB6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 031/102] iwlwifi: mvm: fix bug in scan ssid
Date: Thu,  8 Aug 2013 18:57:07 -0700
Message-Id: <20130809015017.162205198@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Spinadel <david.spinadel@intel.com>

commit fe04e83706037802c502ea41c0d1799ec35fc0d7 upstream.

Increment index in each iteration. Without this increment we are
overriding the added SSIDs and we will send only the last SSId
and (n_ssids - 1) broadcast probes.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -137,8 +137,8 @@ static void iwl_mvm_scan_fill_ssids(stru
 {
 	int fw_idx, req_idx;
 
-	fw_idx = 0;
-	for (req_idx = req->n_ssids - 1; req_idx > 0; req_idx--) {
+	for (req_idx = req->n_ssids - 1, fw_idx = 0; req_idx > 0;
+	     req_idx--, fw_idx++) {
 		cmd->direct_scan[fw_idx].id = WLAN_EID_SSID;
 		cmd->direct_scan[fw_idx].len = req->ssids[req_idx].ssid_len;
 		memcpy(cmd->direct_scan[fw_idx].ssid,


