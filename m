Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab3JKTlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:41:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324Ab3JKTlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David R <david@unsolicited.net>,
        =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Leroy?= <fredo@starox.org>,
        Hayes Wang <hayeswang@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 016/135] r8169: enforce RX_MULTI_EN for the 8168f.
Date: Fri, 11 Oct 2013 12:38:17 -0700
Message-Id: <20131011193947.004916948@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4230,6 +4230,7 @@ static void rtl_init_rxcfg(struct rtl816
 	case RTL_GIGA_MAC_VER_23:
 	case RTL_GIGA_MAC_VER_24:
 	case RTL_GIGA_MAC_VER_34:
+	case RTL_GIGA_MAC_VER_35:
 		RTL_W32(RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST);
 		break;
 	case RTL_GIGA_MAC_VER_40:


