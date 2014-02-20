Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbaBUAlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:41:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45673 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbaBTXwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:52:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.12 21/82] iwlwifi: mvm: print the version of the firmware when it asserts
Date: Thu, 20 Feb 2014 15:52:04 -0800
Message-Id: <20140220235020.117540285@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit b900a87b2eb90c0b9586496c82a323a1b8832d73 upstream.

This can be useful to be able to spot the firmware version
from the error reports without needing to fetch it from
another place.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/utils.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -411,6 +411,8 @@ void iwl_mvm_dump_nic_error_log(struct i
 			mvm->status, table.valid);
 	}
 
+	IWL_ERR(mvm, "Loaded firmware version: %s\n", mvm->fw->fw_version);
+
 	trace_iwlwifi_dev_ucode_error(trans->dev, table.error_id, table.tsf_low,
 				      table.data1, table.data2, table.data3,
 				      table.blink1, table.blink2, table.ilink1,


