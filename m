Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965132Ab3CZPyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:54:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53756 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965022Ab3CZPWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Lingzhu Xiang <lxiang@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 055/150] rt2x00: error in configurations with mesh support disabled
Date: Tue, 26 Mar 2013 15:19:14 +0000
Message-Id: <1364311249-14454-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lingzhu Xiang <lxiang@redhat.com>

commit 6ef9e2f6d12ce9e2120916804d2ddd46b954a70b upstream.

Backported for 3.4-stable. Removed code of simultaneous AP and mesh
mode added in 4a5fc6d 3.9-rc1.

From: Felix Fietkau <nbd@openwrt.org>

If CONFIG_MAC80211_MESH is not set, cfg80211 will now allow advertising
interface combinations with NL80211_IFTYPE_MESH_POINT present.
Add appropriate ifdefs to avoid running into errors.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Reviewed-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 0cf05c3..499c68f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1157,7 +1157,9 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 		rt2x00dev->hw->wiphy->interface_modes |=
 		    BIT(NL80211_IFTYPE_ADHOC) |
 		    BIT(NL80211_IFTYPE_AP) |
+#ifdef CONFIG_MAC80211_MESH
 		    BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
 		    BIT(NL80211_IFTYPE_WDS);
 
 	/*
-- 
1.8.1.2

