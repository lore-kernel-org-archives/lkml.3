Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaGQDzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 23:55:52 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:45716 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751897AbaGQDzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 23:55:50 -0400
From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>
To: Dave Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>, hayeswang@realtek.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] r8169: Enable RX_MULTI_EN for RTL_GIGA_MAC_VER_40
Date: Thu, 17 Jul 2014 12:55:40 +0900
Message-Id: <1405569340-31507-1-git-send-email-michel@daenzer.net>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140716.202945.2231269352453909430.davem@davemloft.net>
References: <20140716.202945.2231269352453909430.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ethernet port on my ASUS A88X Pro mainboard stopped working
several times a day, with messages like these in dmesg:

AMD-Vi: Event logged [IO_PAGE_FAULT device=05:00.0 domain=0x001e address=0x0000000000003000 flags=0x0050]

Searching the web for these messages led me to similar reports about
different hardware supported by r8169, and eventually to commits
3ced8c955e74d319f3e3997f7169c79d524dfd06 ('r8169: enforce RX_MULTI_EN
for the 8168f.') and eb2dc35d99028b698cdedba4f5522bc43e576bd2 ('r8169:
RxConfig hack for the 8168evl'). So I tried this change, and it fixes
the problem for me.

Signed-off-by: Michel Dänzer <michel@daenzer.net>
---

v2: Updated commit log, how about this?

 drivers/net/ethernet/realtek/r8169.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 06bdc31..61623e9 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4240,6 +4240,8 @@ static void rtl_init_rxcfg(struct rtl8169_private *tp)
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

