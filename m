Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab3KHCYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:24:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34942 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab3KHCWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:22:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 50/91] rtlwifi: rtl8192cu: Fix error in pointer arithmetic
Date: Thu,  7 Nov 2013 18:15:05 -0800
Message-Id: <1383876946-2396-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>

commit 9473ca6e920a3b9ca902753ce52833657f9221cc upstream.

An error in calculating the offset in an skb causes the driver to read
essential device info from the wrong locations. The main effect is that
automatic gain calculations are nonsense.

Signed-off-by: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index b6222ee..03b6d81 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -343,7 +343,8 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 					(bool)GET_RX_DESC_PAGGR(pdesc));
 	rx_status->mactime = GET_RX_DESC_TSFL(pdesc);
 	if (phystatus) {
-		p_drvinfo = (struct rx_fwinfo_92c *)(pdesc + RTL_RX_DESC_SIZE);
+		p_drvinfo = (struct rx_fwinfo_92c *)(skb->data +
+						     stats->rx_bufshift);
 		rtl92c_translate_rx_signal_stuff(hw, skb, stats, pdesc,
 						 p_drvinfo);
 	}
-- 
1.8.1.2

