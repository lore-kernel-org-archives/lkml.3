Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761Ab3KOMAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:00:21 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:50053 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab3KOMAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:00:17 -0500
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: geyslan@gmail.com
Cc: Brett Rudley <brudley@broadcom.com>, Arend van Spriel <arend@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Piotr Haber <phaber@broadcom.com>,
        linux-wireless@vger.kernel.org (open list:BROADCOM BRCM8021...),
        brcm80211-dev-list@broadcom.com (open list:BROADCOM BRCM8021...),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] brcmfmac: fix possible memory leak
Date: Fri, 15 Nov 2013 08:54:17 -0300
Message-Id: <1384516475-26589-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of error free 'chanspecs'.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index d7a9745..aea2c2e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -771,7 +771,7 @@ static s32 brcmf_p2p_run_escan(struct brcmf_cfg80211_info *cfg,
 	struct brcmf_cfg80211_vif *vif;
 	struct net_device *dev = NULL;
 	int i, num_nodfs = 0;
-	u16 *chanspecs;
+	u16 *chanspecs = NULL;
 
 	brcmf_dbg(TRACE, "enter\n");
 
@@ -825,8 +825,10 @@ static s32 brcmf_p2p_run_escan(struct brcmf_cfg80211_info *cfg,
 				      action, P2PAPI_BSSCFG_DEVICE);
 	}
 exit:
-	if (err)
+	if (err) {
 		brcmf_err("error (%d)\n", err);
+		kfree(chanspecs);
+	}
 	return err;
 }
 
-- 
1.8.4.2

