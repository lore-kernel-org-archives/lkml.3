Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbaBDVC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:02:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193AbaBDVCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:02:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eliad Peller <eliadx.peller@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.10 037/104] iwlwifi: mvm: fix missing cleanup in .start() error path
Date: Tue,  4 Feb 2014 13:01:40 -0800
Message-Id: <20140204210223.782925881@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
References: <20140204210222.731641778@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliadx.peller@intel.com>

commit 91b0d1198417cf4fd9a7bd4138b6909f0b359099 upstream.

Cleanup of iwl_mvm_leds was missing in case of error,
resulting in the following warning:

WARNING: at lib/kobject.c:196 kobject_add_internal+0x1f4/0x210()
kobject_add_internal failed for phy0-led with -EEXIST, don't try to register things with the same name in the same directory.

which prevents further reloads of the driver.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/ops.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -424,6 +424,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *
 
  out_unregister:
 	ieee80211_unregister_hw(mvm->hw);
+	iwl_mvm_leds_exit(mvm);
  out_free:
 	iwl_phy_db_free(mvm->phy_db);
 	kfree(mvm->scan_cmd);


