Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394AbaDBJ65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 05:58:57 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:58072 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758197AbaDBJ6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 05:58:54 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Tom Gundersen <teg@jklm.no>,
        Johannes berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH v6 4/4] brcmfmac: set NET_NAME_USER for P2P ifs
Date: Wed,  2 Apr 2014 11:58:26 +0200
Message-Id: <1396432706-14470-5-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396432706-14470-1-git-send-email-dh.herrmann@gmail.com>
References: <1396432706-14470-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netdevs created via nl80211 (currently only P2P ifs) have names provided
by user-space. Therefore, set the naming-policy to NET_NAME_USER so it is
correctly shown in sysfs.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Acked-by: Arend van Spriel <arend@broadcom.com>
Acked-by: Tom Gundersen <teg@jklm.no>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index f3445ac..f721ed6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -2308,6 +2308,7 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 		goto fail;
 	}
 
+	ifp->ndev->name_assign_type = NET_NAME_USER;
 	strncpy(ifp->ndev->name, name, sizeof(ifp->ndev->name) - 1);
 	err = brcmf_net_attach(ifp, true);
 	if (err) {
-- 
1.9.1

