Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab3CDDoF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:44:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32956 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756363Ab3CDDoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:02 -0500
Message-Id: <20130304033714.986238125@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:22 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Bastian Bittorf <bittorf@bluebottle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 075/153] b43: Increase number of RX DMA slots
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit ccae0e50c16a7f7adb029c169147400d1ce9f703 upstream.

Bastian Bittorf reported that some of the silent freezes on a Linksys WRT54G
were due to overflow of the RX DMA ring buffer, which was created with 64
slots. That finding reminded me that I was seeing similar crashed on a netbook,
which also has a relatively slow processor. After increasing the number of
slots to 128, runs on the netbook that previously failed now worked; however,
I found that 109 slots had been used in one test. For that reason, the number
of slots is being increased to 256.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Bastian Bittorf <bittorf@bluebottle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/b43/dma.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/b43/dma.h
+++ b/drivers/net/wireless/b43/dma.h
@@ -169,7 +169,7 @@ struct b43_dmadesc_generic {
 
 /* DMA engine tuning knobs */
 #define B43_TXRING_SLOTS		256
-#define B43_RXRING_SLOTS		64
+#define B43_RXRING_SLOTS		256
 #define B43_DMA0_RX_FW598_BUFSIZE	(B43_DMA0_RX_FW598_FO + IEEE80211_MAX_FRAME_LEN)
 #define B43_DMA0_RX_FW351_BUFSIZE	(B43_DMA0_RX_FW351_FO + IEEE80211_MAX_FRAME_LEN)
 


