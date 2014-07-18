Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161342AbaGRN0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:26:01 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17914 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161214AbaGRNRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:17:15 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
        Arik Nemtsov <arikx.nemtsov@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 097/170] mac80211: don't check netdev state for debugfs read/write
Date: Fri, 18 Jul 2014 14:11:42 +0200
Message-Id: <3174f2792732ea8528fffbbb42cd4d5ca484be31.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arik Nemtsov <arik@wizery.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 923eaf367206e01f22c97aee22300e332d071916 upstream.

Doing so will lead to an oops for a p2p-dev interface, since it has
no netdev.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/mac80211/debugfs_netdev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index cafe614ef93d..8e41f0163c5a 100644
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
2.0.0

