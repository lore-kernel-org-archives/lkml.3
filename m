Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760097Ab3DBXTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:19:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752Ab3DBWMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 019/124] iwlwifi: fix length check in multi-TB HCMD
Date: Tue,  2 Apr 2013 15:10:01 -0700
Message-Id: <20130402221106.430435378@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit cc904c7188c29847817f35e6966fec3014c7479b upstream.

As reported by Ben Hutchings, there was a harmless issue in
the checks being done on the lengths of the TBs while
building the TFD for a multi-TB host command.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/pcie/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1242,7 +1242,7 @@ static int iwl_pcie_enqueue_hcmd(struct
 	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
 		int copy = 0;
 
-		if (!cmd->len)
+		if (!cmd->len[i])
 			continue;
 
 		/* need at least IWL_HCMD_MIN_COPY_SIZE copied */


