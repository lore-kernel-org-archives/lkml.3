Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab3I3PiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:38:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64841 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab3I3PiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:38:18 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-d4-52499ae98272
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2] ARM: at91: cam60: fix incorrect placement of __initdata tag
Date: Mon, 30 Sep 2013 17:38:06 +0200
Message-id: <4748525.slmbI8ubRr@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t9jQd2XszyDDObN5bA42/SG3WLT42us
	Fpd3zWGzWL7iKbPFt8vN7BbrHr5gcmDzWPBrK4vHqwt3WDw2L6n3mHh7GotH35ZVjB6fN8kF
	sEVx2aSk5mSWpRbp2yVwZdy8tpy94B57xf7uN8wNjCvZuhg5OSQETCSWLtzGCGGLSVy4tx4o
	zsUhJDCdUeLlu0XsEE4Lk8TkF8eZQarYBKwkJravAurg4BARUJM43lEJEmYWuMUoMe+LNYgt
	LOAv0Xb5KAtICYuAqsTmXl+QMK+ApsSCyz/B9ooKeEp8mrSUGSIuKPFj8j0WiDHyEvv2T2WF
	sLUk1u88zjSBkW8WkrJZSMpmISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4YJ9J
	72Bc1WBxiFGAg1GJh9eg3jNIiDWxrLgy9xCjBAezkgjv6wlAId6UxMqq1KL8+KLSnNTiQ4zS
	HCxK4rwHW60DhQTSE0tSs1NTC1KLYLJMHJxSDYxijgdOGbtkZytWP3m2x8Z0/oYI/6tXLXPE
	LwZVrhH9defJS5MjZtsTxUuNF14JuLtoztaj/XVtz754FqcZl6UHz9V/aa71h+v8Pc9Xx6Zp
	zVs/7fVqf7dnHCsXXeqsY7F6c5274HJs2x6t2vAlDr1uwUfeswZd4l1xrENl56l52Xkbg0Qv
	vctTYinOSDTUYi4qTgQA9fut9FQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__initdata tag should be placed between the variable name and equal
sign for the variable to be placed in the intended .init.data section.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v2:
- use __initdata as it is OK to do it

 arch/arm/mach-at91/board-cam60.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/mach-at91/board-cam60.c b/arch/arm/mach-at91/board-cam60.c
index ade948b..ecabbed 100644
--- a/arch/arm/mach-at91/board-cam60.c
+++ b/arch/arm/mach-at91/board-cam60.c
@@ -108,16 +108,14 @@ static struct spi_board_info cam60_spi_devices[] __initdata = {
 #endif
 };
 
-
 /*
  * MACB Ethernet device
  */
-static struct __initdata macb_platform_data cam60_macb_data = {
+static struct macb_platform_data cam60_macb_data __initdata = {
 	.phy_irq_pin	= AT91_PIN_PB5,
 	.is_rmii	= 0,
 };
 
-
 /*
  * NAND Flash
  */
-- 
1.8.2.3


