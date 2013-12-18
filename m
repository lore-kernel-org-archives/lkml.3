Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3LRWD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:03:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3LRVMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.10 42/78] iwlwifi: mvm: check sta_id/drain values in debugfs
Date: Wed, 18 Dec 2013 13:11:10 -0800
Message-Id: <20131218211113.091336216@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 60765a47a433d54e4744c285ad127f182dcd80aa upstream.

The station ID must be valid, if it's out of range then
the array access may crash. Validate the station ID to
the array length, and also validate the drain value even
if that doesn't matter all that much.

Fixes: 8ca151b568b6 ("iwlwifi: add the MVM driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -119,6 +119,10 @@ static ssize_t iwl_dbgfs_sta_drain_write
 
 	if (sscanf(buf, "%d %d", &sta_id, &drain) != 2)
 		return -EINVAL;
+	if (sta_id < 0 || sta_id >= IWL_MVM_STATION_COUNT)
+		return -EINVAL;
+	if (drain < 0 || drain > 1)
+		return -EINVAL;
 
 	mutex_lock(&mvm->mutex);
 


