Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3J2SJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:09:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59556 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab3J2SJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hayes Wang <hayeswang@realtek.com>, Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 35/81] r8169: enforce RX_MULTI_EN for the 8168f.
Date: Tue, 29 Oct 2013 11:03:56 -0700
Message-Id: <1383069882-11437-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?fran=C3=A7ois=20romieu?= <romieu@fr.zoreil.com>

[ Upstream commit 3ced8c955e74d319f3e3997f7169c79d524dfd06 ]

Same narrative as eb2dc35d99028b698cdedba4f5522bc43e576bd2 ("r8169: RxConfig
hack for the 8168evl.") regarding AMD IOMMU errors.

RTL_GIGA_MAC_VER_36 - 8168f as well - has not been reported to behave the
same.

Tested-by: David R <david@unsolicited.net>
Tested-by: Frédéric Leroy <fredo@starox.org>
Cc: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/realtek/r8169.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 4fa28fe..996318b 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4148,6 +4148,7 @@ static void rtl_init_rxcfg(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_23:
 	case RTL_GIGA_MAC_VER_24:
 	case RTL_GIGA_MAC_VER_34:
+	case RTL_GIGA_MAC_VER_35:
 		RTL_W32(RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST);
 		break;
 	default:
-- 
1.8.1.2

