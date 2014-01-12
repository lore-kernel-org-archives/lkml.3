Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbaALJk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 04:40:28 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35163 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaALJkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 04:40:25 -0500
Date: Sun, 12 Jan 2014 17:39:52 +0800
From: Bruce Liu <damuzi000@gmail.com>
To: peppe.cavallaro@st.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, damuzi000@gmail.com
Subject: Re: [PATCH 1/1] When timestamping is enabled, stmmac_tx_clean will
 call stmmac_get_tx_hwtstamp to get tx TS. It's possible that skb is NULL
 because there are other network frames that use several descriptors. So we
 must return immediately in stmmac_get_tx_hwtstamp if skb is NULL to avoid
 system crash.
Message-ID: <20140112093951.GA3743@gmail.com>
References: <1389492095-6589-1-git-send-email-damuzi000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389492095-6589-1-git-send-email-damuzi000@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 When timestamping is enabled, stmmac_tx_clean will call stmmac_get_tx_hwtstamp to get tx TS.
 It's possible that skb is NULL because there are other network frames that use several descriptors.
 So we must return immediately in stmmac_get_tx_hwtstamp if skb is NULL to avoid system crash.


Signed-off-by: Bruce Liu <damuzi000@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 797b56a..47f2287 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -332,7 +332,7 @@ static void stmmac_get_tx_hwtstamp(struct stmmac_priv *priv,
 		return;
 
 	/* exit if skb doesn't support hw tstamp */
-	if (likely(!(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)))
+	if (likely(!skb || !(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)))
 		return;
 
 	if (priv->adv_ts)
-- 
1.7.9.5

 
