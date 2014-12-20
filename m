Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaLTM1P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 07:27:15 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:38428 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaLTM1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 07:27:13 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: ipw2x00: ipw2200.c:  Remove unused function
Date: Sat, 20 Dec 2014 13:29:59 +0100
Message-Id: <1419078599-31118-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function ipw_alive() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/wireless/ipw2x00/ipw2200.c |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index edc3443..2f830ca 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -3021,20 +3021,6 @@ static void ipw_remove_current_network(struct ipw_priv *priv)
 	spin_unlock_irqrestore(&priv->ieee->lock, flags);
 }
 
-/**
- * Check that card is still alive.
- * Reads debug register from domain0.
- * If card is present, pre-defined value should
- * be found there.
- *
- * @param priv
- * @return 1 if card is present, 0 otherwise
- */
-static inline int ipw_alive(struct ipw_priv *priv)
-{
-	return ipw_read32(priv, 0x90) == 0xd55555d5;
-}
-
 /* timeout in msec, attempted in 10-msec quanta */
 static int ipw_poll_bit(struct ipw_priv *priv, u32 addr, u32 mask,
 			       int timeout)
-- 
1.7.10.4

