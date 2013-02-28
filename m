Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab3B1PKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:10:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42187 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273Ab3B1Os2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:48:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Bastian Bittorf <bittorf@bluebottle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 064/139] b43: Increase number of RX DMA slots
Date: Thu, 28 Feb 2013 14:43:34 +0000
Message-Id: <1362062689-2567-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/b43/dma.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/dma.h b/drivers/net/wireless/b43/dma.h
index 315b96e..9fdd198 100644
--- a/drivers/net/wireless/b43/dma.h
+++ b/drivers/net/wireless/b43/dma.h
@@ -169,7 +169,7 @@ struct b43_dmadesc_generic {
 
 /* DMA engine tuning knobs */
 #define B43_TXRING_SLOTS		256
-#define B43_RXRING_SLOTS		64
+#define B43_RXRING_SLOTS		256
 #define B43_DMA0_RX_FW598_BUFSIZE	(B43_DMA0_RX_FW598_FO + IEEE80211_MAX_FRAME_LEN)
 #define B43_DMA0_RX_FW351_BUFSIZE	(B43_DMA0_RX_FW351_FO + IEEE80211_MAX_FRAME_LEN)
 
-- 
1.8.1.2

