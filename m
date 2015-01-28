Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184AbbA1BhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:37:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760020AbbA1B2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.18 57/61] iwlwifi: mvm: add a flag to enable match found notification
Date: Tue, 27 Jan 2015 17:27:09 -0800
Message-Id: <20150128012643.129674096@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Spinadel <david.spinadel@intel.com>

commit 7e2a38831db4cf082aa8b4997f3cbfe8cb03b669 upstream.

Add a flag that enables match found notification to align with
FW API change.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |    2 ++
 drivers/net/wireless/iwlwifi/mvm/scan.c        |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -672,6 +672,7 @@ struct iwl_scan_channel_opt {
  * @IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED: all passive scans will be fragmented
  * @IWL_MVM_LMAC_SCAN_FLAGS_RRM_ENABLED: insert WFA vendor-specific TPC report
  *	and DS parameter set IEs into probe requests.
+ * @IWL_MVM_LMAC_SCAN_FLAG_MATCH: Send match found notification on matches
  */
 enum iwl_mvm_lmac_scan_flags {
 	IWL_MVM_LMAC_SCAN_FLAG_PASS_ALL		= BIT(0),
@@ -681,6 +682,7 @@ enum iwl_mvm_lmac_scan_flags {
 	IWL_MVM_LMAC_SCAN_FLAG_MULTIPLE_SSIDS	= BIT(4),
 	IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED	= BIT(5),
 	IWL_MVM_LMAC_SCAN_FLAGS_RRM_ENABLED	= BIT(6),
+	IWL_MVM_LMAC_SCAN_FLAG_MATCH		= BIT(9),
 };
 
 enum iwl_scan_priority {
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1334,6 +1334,7 @@ int iwl_mvm_unified_sched_scan_lmac(stru
 		IWL_DEBUG_SCAN(mvm,
 			       "Sending scheduled scan with filtering, n_match_sets %d\n",
 			       req->n_match_sets);
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_MATCH;
 	} else {
 		IWL_DEBUG_SCAN(mvm,
 			       "Sending Scheduled scan without filtering\n");


