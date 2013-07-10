Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab3GJVDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 17:03:49 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:35259 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab3GJVDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 17:03:47 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] rt2x00: RT2X00 should depend on HAS_DMA
Date: Wed, 10 Jul 2013 23:03:35 +0200
Message-Id: <1373490216-12437-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373490216-12437-1-git-send-email-geert@linux-m68k.org>
References: <1373490216-12437-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `rt2x00queue_unmap_skb':
drivers/net/wireless/rt2x00/rt2x00queue.c:129: undefined reference to `dma_unmap_single'
drivers/net/wireless/rt2x00/rt2x00queue.c:133: undefined reference to `dma_unmap_single'
drivers/built-in.o: In function `rt2x00queue_map_txskb':
drivers/net/wireless/rt2x00/rt2x00queue.c:112: undefined reference to `dma_map_single'
drivers/net/wireless/rt2x00/rt2x00queue.c:115: undefined reference to `dma_mapping_error'
drivers/built-in.o: In function `rt2x00queue_alloc_rxskb':
drivers/net/wireless/rt2x00/rt2x00queue.c:93: undefined reference to `dma_map_single'
drivers/net/wireless/rt2x00/rt2x00queue.c:95: undefined reference to `dma_mapping_error'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/rt2x00/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 9b915d3..3e60a31 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -1,6 +1,6 @@
 menuconfig RT2X00
 	tristate "Ralink driver support"
-	depends on MAC80211
+	depends on MAC80211 && HAS_DMA
 	---help---
 	  This will enable the support for the Ralink drivers,
 	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.
-- 
1.7.9.5

