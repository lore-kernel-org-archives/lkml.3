Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479Ab3FEWJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:09:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37648 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab3FEVfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ilan Peer <ilan.peer@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 016/127] iwlwifi: mvm: Always use SCAN_TYPE_FORCED
Date: Wed,  5 Jun 2013 14:33:03 -0700
Message-Id: <20130605213219.873332223@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

commit f70ed7b330ce769828d402f920fb13da6c13ea63 upstream.

The FW AUX framework does not handle well cases where time events
fail to be scheduled (and as a result issues assert 0x3330). Until
a proper fix is in place, WA this by always setting the scan type to
SCAN_TYPE_FORCED.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/scan.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -298,6 +298,12 @@ int iwl_mvm_scan_request(struct iwl_mvm
 	else
 		cmd->type = cpu_to_le32(SCAN_TYPE_FORCED);
 
+	/*
+	 * TODO: This is a WA due to a bug in the FW AUX framework that does not
+	 * properly handle time events that fail to be scheduled
+	 */
+	cmd->type = cpu_to_le32(SCAN_TYPE_FORCED);
+
 	cmd->repeats = cpu_to_le32(1);
 
 	/*


