Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086Ab3BZX5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:57:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760007Ab3BZX5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Bastian Bittorf <bittorf@bluebottle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 020/150] b43: Increase number of RX DMA slots
Date: Tue, 26 Feb 2013 15:54:37 -0800
Message-Id: <20130226235526.339079672@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
 


