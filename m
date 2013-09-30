Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab3I3NAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:00:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:53740 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab3I3NAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:00:48 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-32-524975ffd452
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] ARM: at91: cam60: fix incorrect placement of __initdata tag
Date: Mon, 30 Sep 2013 15:00:36 +0200
Message-id: <1547748.5rp6t7JgE3@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t9jAd3/pZ5BBtu+6FucbXrDbrHp8TVW
	i8u75rBZLF/xlNni2+Vmdot1D18wObB5LPi1lcXj1YU7LB6bl9R7TLw9jcWjb8sqRo/Pm+QC
	2KK4bFJSczLLUov07RK4Mi78vchYcJCj4vuhW6wNjP/Yuhg5OSQETCTW/DkPZYtJXLi3Hsjm
	4hASWMQo8fDjUWaQhJBAC5PEzellIDabgJXExPZVjF2MHBwiAmoSxzsqQcLMArcYJeZ9sQax
	hQV8JFYeecQEYrMIqEq0LTkCNp9XQFNiw+2ZYLaogKfEp0lLmSHighI/Jt9jgZgjL7Fv/1RW
	CFtLYv3O40wTGPlmISmbhaRsFpKyBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCA/aZ
	1A7GlQ0WhxgFOBiVeHgnLPcIEmJNLCuuzD3EKMHBrCTCOyHLM0iINyWxsiq1KD++qDQntfgQ
	ozQHi5I474FW60AhgfTEktTs1NSC1CKYLBMHp1QDo0KPlYl7jZ9+aqOydu9UXcPNm2duaMqd
	+Hfj8taCbY6lnPYnw+2+fioq93z7ULy8Z61D5Bd2vZ0d379e4Js44SpDpL6p6z0T8zmh5xY9
	d9k64XCH9CehyZu6JoRLPNsYlft9ufWRli+OO+Zqv72zyenCO0/nBe/6pzrPuxp6ZnLIhKkM
	V682ZCqxFGckGmoxFxUnAgC67Z8TVAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__initdata tag should be placed between the variable name and equal
sign for the variable to be placed in the intended .init.data section.

In this particular case __initdata is incorrect as cam60_macb_data
can be used as a platform data for at91_eth driver which can be
compiled as module.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
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
+static struct macb_platform_data cam60_macb_data = {
 	.phy_irq_pin	= AT91_PIN_PB5,
 	.is_rmii	= 0,
 };
 
-
 /*
  * NAND Flash
  */
-- 
1.8.2.3


