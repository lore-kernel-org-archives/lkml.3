Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbaCPRW4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 13:22:56 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:56147 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbaCPRV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 13:21:58 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Tom Gundersen <teg@jklm.no>,
        Johannes berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH v2 4/4] brcmfmac: set NET_NAME_USER for P2P ifs
Date: Sun, 16 Mar 2014 18:21:30 +0100
Message-Id: <1394990490-1076-5-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394990490-1076-1-git-send-email-dh.herrmann@gmail.com>
References: <1394990490-1076-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netdevs created via nl80211 (currently only P2P ifs) have names provided
by user-space. Therefore, set the naming-policy to NET_NAME_USER so it is
correctly shown in sysfs.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Acked-by: Arend van Spriel <arend@broadcom.com>
Acked-by: Tom Gundersen <teg@jklm.no>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index fc4f98b..6af4d26 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -2310,6 +2310,7 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 		goto fail;
 	}
 
+	ifp->ndev->name_assign_type = NET_NAME_USER;
 	strncpy(ifp->ndev->name, name, sizeof(ifp->ndev->name) - 1);
 	err = brcmf_net_attach(ifp, true);
 	if (err) {
-- 
1.9.0

