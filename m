Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934584Ab3DGX0o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:26:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46583 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934461Ab3DGX0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:26:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Felix Fietkau" <nbd@openwrt.org>,
        "Lingzhu Xiang" <lxiang@redhat.com>,
        "Gertjan van Wingerde" <gwingerde@gmail.com>,
        "CAI Qian" <caiqian@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.658465583@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [47/74] rt2x00: error in configurations with  mesh support disabled
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 6ef9e2f6d12ce9e2120916804d2ddd46b954a70b upstream.

If CONFIG_MAC80211_MESH is not set, cfg80211 will now allow advertising
interface combinations with NL80211_IFTYPE_MESH_POINT present.
Add appropriate ifdefs to avoid running into errors.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[lxiang: Backported for 3.4-stable. Removed code of simultaneous AP and mesh
 mode added in 4a5fc6d 3.9-rc1.]
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Reviewed-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1146,7 +1146,9 @@ int rt2x00lib_probe_dev(struct rt2x00_de
 		rt2x00dev->hw->wiphy->interface_modes |=
 		    BIT(NL80211_IFTYPE_ADHOC) |
 		    BIT(NL80211_IFTYPE_AP) |
+#ifdef CONFIG_MAC80211_MESH
 		    BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
 		    BIT(NL80211_IFTYPE_WDS);
 
 	/*

