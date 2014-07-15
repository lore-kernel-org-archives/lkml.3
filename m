Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462AbaGOGly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 02:41:54 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:43670 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932269AbaGOGlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 02:41:53 -0400
From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>
To: Francois Romieu <romieu@fr.zoreil.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] r8169: Enable RX_MULTI_EN for RTL_GIGA_MAC_VER_40
Date: Tue, 15 Jul 2014 15:41:40 +0900
Message-Id: <1405406500-1208-1-git-send-email-michel@daenzer.net>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this, the ethernet port on my ASUS A88X Pro mainboard stops
working sometimes, with messages like these in dmesg:

AMD-Vi: Event logged [IO_PAGE_FAULT device=05:00.0 domain=0x001e address=0x0000000000003000 flags=0x0050]
Signed-off-by: Michel Dänzer <michel@daenzer.net>
---
 drivers/net/ethernet/realtek/r8169.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index be425ad..e577566 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4239,6 +4239,8 @@ static void rtl_init_rxcfg(struct rtl8169_private *tp)
 		RTL_W32(RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST);
 		break;
 	case RTL_GIGA_MAC_VER_40:
+		RTL_W32(RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST | RX_EARLY_OFF);
+		break;
 	case RTL_GIGA_MAC_VER_41:
 	case RTL_GIGA_MAC_VER_42:
 	case RTL_GIGA_MAC_VER_43:
-- 
2.0.0

