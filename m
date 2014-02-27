Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaB0Ord (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:47:33 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:38764 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaB0Or3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:47:29 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Kay Sievers <kay.sievers@vrfy.org>, Tom Gundersen <teg@jklm.no>,
        Johannes berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/4] mac80211: set NET_NAME_USER for user-space created ifs
Date: Thu, 27 Feb 2014 15:47:12 +0100
Message-Id: <1393512434-1325-3-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393512434-1325-1-git-send-email-dh.herrmann@gmail.com>
References: <1393512434-1325-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nl80211 interface allows creating new netdevs from user-space. The
name is *always* provided by user-space, so we should set NET_NAME_USER to
provide that information via sysfs.

This allows udev to not rename dynamically created wifi devices (like wifi
P2P devices).

Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 net/mac80211/iface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ce1c443..35561bd 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1620,6 +1620,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 					+ IEEE80211_ENCRYPT_HEADROOM;
 		ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
 
+		ndev->name_assign_type = NET_NAME_USER;
 		ret = dev_alloc_name(ndev, ndev->name);
 		if (ret < 0) {
 			free_netdev(ndev);
-- 
1.9.0

