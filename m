Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162AbaGVWZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:25:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44685 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933107AbaGVWZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:25:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arik Nemtsov <arikx.nemtsov@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 040/116] mac80211: don't check netdev state for debugfs read/write
Date: Tue, 22 Jul 2014 15:20:51 -0700
Message-Id: <1406067727-19683-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arik Nemtsov <arik@wizery.com>

commit 923eaf367206e01f22c97aee22300e332d071916 upstream.

Doing so will lead to an oops for a p2p-dev interface, since it has
no netdev.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/debugfs_netdev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index cbde5cc..8736537 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -34,8 +34,7 @@ static ssize_t ieee80211_if_read(
 	ssize_t ret = -EINVAL;
 
 	read_lock(&dev_base_lock);
-	if (sdata->dev->reg_state == NETREG_REGISTERED)
-		ret = (*format)(sdata, buf, sizeof(buf));
+	ret = (*format)(sdata, buf, sizeof(buf));
 	read_unlock(&dev_base_lock);
 
 	if (ret >= 0)
@@ -62,8 +61,7 @@ static ssize_t ieee80211_if_write(
 
 	ret = -ENODEV;
 	rtnl_lock();
-	if (sdata->dev->reg_state == NETREG_REGISTERED)
-		ret = (*write)(sdata, buf, count);
+	ret = (*write)(sdata, buf, count);
 	rtnl_unlock();
 
 	return ret;
-- 
1.9.1

