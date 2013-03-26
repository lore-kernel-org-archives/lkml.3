Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab3CZWqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:46:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52732 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab3CZWok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Lingzhu Xiang <lxiang@redhat.com>, CAI Qian <caiqian@redhat.com>
Subject: [ 98/98] rt2x00: error in configurations with mesh support disabled
Date: Tue, 26 Mar 2013 15:43:27 -0700
Message-Id: <20130326224252.616310498@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 6ef9e2f6d12ce9e2120916804d2ddd46b954a70b upstream.

If CONFIG_MAC80211_MESH is not set, cfg80211 will now allow advertising
interface combinations with NL80211_IFTYPE_MESH_POINT present.
Add appropriate ifdefs to avoid running into errors.

[Backported for 3.8-stable. Removed code of simultaneous AP and mesh
mode added in 4a5fc6d 3.9-rc1.]

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Reviewed-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1209,7 +1209,9 @@ int rt2x00lib_probe_dev(struct rt2x00_de
 		rt2x00dev->hw->wiphy->interface_modes |=
 		    BIT(NL80211_IFTYPE_ADHOC) |
 		    BIT(NL80211_IFTYPE_AP) |
+#ifdef CONFIG_MAC80211_MESH
 		    BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
 		    BIT(NL80211_IFTYPE_WDS);
 
 	rt2x00dev->hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;


