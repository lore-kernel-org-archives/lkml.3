Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630AbaJDAGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:06:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbaJCVxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luciano Coelho <luciano.coelho@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.16 243/357] iwlwifi: mvm: set MAC_FILTER_IN_BEACON correctly for STA/P2P client
Date: Fri,  3 Oct 2014 14:30:29 -0700
Message-Id: <20141003212940.803833037@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luciano Coelho <luciano.coelho@intel.com>

commit 7c8b3bc688bdcfd7789efbd17da4d85b104ad351 upstream.

In commit cad3f08c (iwlwifi: mvm: enable MAC_FILTER_IN_BEACON when
forced_assoc_off is set) the code to set the MAC_FILTER_IN_BEACON flag
was accidentally moved to the main block of the if statement, while it
should be in the else block instead.  Move it to the right place.

Fixes: cad3f08c23de ("iwlwifi: mvm: enable MAC_FILTER_IN_BEACON when forced_assoc_off is set")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -720,11 +720,6 @@ static int iwl_mvm_mac_ctxt_cmd_sta(stru
 	    !force_assoc_off) {
 		u32 dtim_offs;
 
-		/* Allow beacons to pass through as long as we are not
-		 * associated, or we do not have dtim period information.
-		 */
-		cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_BEACON);
-
 		/*
 		 * The DTIM count counts down, so when it is N that means N
 		 * more beacon intervals happen until the DTIM TBTT. Therefore
@@ -758,6 +753,11 @@ static int iwl_mvm_mac_ctxt_cmd_sta(stru
 		ctxt_sta->is_assoc = cpu_to_le32(1);
 	} else {
 		ctxt_sta->is_assoc = cpu_to_le32(0);
+
+		/* Allow beacons to pass through as long as we are not
+		 * associated, or we do not have dtim period information.
+		 */
+		cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_BEACON);
 	}
 
 	ctxt_sta->bi = cpu_to_le32(vif->bss_conf.beacon_int);


