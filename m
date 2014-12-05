Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaLEWte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:49:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaLEWqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.17 095/122] iwlwifi: pcie: fix prph dump length
Date: Fri,  5 Dec 2014 14:44:29 -0800
Message-Id: <20141205223320.241655863@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liad Kaufman <liad.kaufman@intel.com>

commit 87dd634ae72bb8f6d0dd12f1cbbc67c7da6dba3b upstream.

The length counting previously done had an error in it, causing
the length down the data dumping function to be shorter than it
should be, causing the end of the data to get truncated off and
lost.

Fixes: 67c65f2cf710 ("iwlwifi: dump periphery registers to fw-error-dump")
Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/pcie/trans.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1891,8 +1891,7 @@ static u32 iwl_trans_pcie_dump_prph(stru
 		int reg;
 		__le32 *val;
 
-		prph_len += sizeof(*data) + sizeof(*prph) +
-			num_bytes_in_chunk;
+		prph_len += sizeof(**data) + sizeof(*prph) + num_bytes_in_chunk;
 
 		(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PRPH);
 		(*data)->len = cpu_to_le32(sizeof(*prph) +


