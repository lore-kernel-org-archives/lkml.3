Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbaCZNGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 09:06:22 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:50432 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbaCZNFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:05:48 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Tom Gundersen <teg@jklm.no>,
        Johannes berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH v5 4/4] brcmfmac: set NET_NAME_USER for P2P ifs
Date: Wed, 26 Mar 2014 14:05:17 +0100
Message-Id: <1395839117-20090-5-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395839117-20090-1-git-send-email-dh.herrmann@gmail.com>
References: <1395839117-20090-1-git-send-email-dh.herrmann@gmail.com>
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

