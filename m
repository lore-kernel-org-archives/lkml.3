Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab3LSM0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:26:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45050 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab3LSL60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 130/208] iwlwifi: mvm: check sta_id/drain values in debugfs
Date: Thu, 19 Dec 2013 11:53:48 +0000
Message-Id: <1387454106-19326-131-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index c24a744..b52e8b6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -119,6 +119,10 @@ static ssize_t iwl_dbgfs_sta_drain_write(struct file *file,
 
 	if (sscanf(buf, "%d %d", &sta_id, &drain) != 2)
 		return -EINVAL;
+	if (sta_id < 0 || sta_id >= IWL_MVM_STATION_COUNT)
+		return -EINVAL;
+	if (drain < 0 || drain > 1)
+		return -EINVAL;
 
 	mutex_lock(&mvm->mutex);
 
-- 
1.8.3.2

