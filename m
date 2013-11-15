Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab3KOM1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:27:24 -0500
Received: from mail-gg0-f182.google.com ([209.85.161.182]:63488 "EHLO
	mail-gg0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3KOM1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:27:17 -0500
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
Subject: [PATCH v2] brcmfmac: fix possible memory leak
Date: Fri, 15 Nov 2013 09:21:47 -0300
Message-Id: <1384518113-3079-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free temporary 'chanspecs' avoiding leakage.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index d7a9745..fcc5e7c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -823,6 +823,7 @@ static s32 brcmf_p2p_run_escan(struct brcmf_cfg80211_info *cfg,
 		}
 		err = brcmf_p2p_escan(p2p, num_nodfs, chanspecs, search_state,
 				      action, P2PAPI_BSSCFG_DEVICE);
+		kfree(chanspecs);
 	}
 exit:
 	if (err)
-- 
1.8.4.2

