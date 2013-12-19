Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab3LSMt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:49:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44791 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3LSL5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 079/208] ARM: at91: sama5d3: reduce TWI internal clock frequency
Date: Thu, 19 Dec 2013 11:52:57 +0000
Message-Id: <1387454106-19326-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ludovic Desroches <ludovic.desroches@atmel.com>

commit 58e7b1d5826ac6a64b1101d8a70162bc084a7d1e upstream.

With some devices, transfer hangs during I2C frame transmission. This issue
disappears when reducing the internal frequency of the TWI IP. Even if it is
indicated that internal clock max frequency is 66MHz, it seems we have
oversampling on I2C signals making TWI believe that a transfer in progress
is done.

This fix has no impact on the I2C bus frequency.

Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Acked-by: Wolfram Sang <wsa@the-dreams.de>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-at91/sama5d3.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-at91/sama5d3.c b/arch/arm/mach-at91/sama5d3.c
index 3ea8642..a28873f 100644
--- a/arch/arm/mach-at91/sama5d3.c
+++ b/arch/arm/mach-at91/sama5d3.c
@@ -95,19 +95,19 @@ static struct clk twi0_clk = {
 	.name		= "twi0_clk",
 	.pid		= SAMA5D3_ID_TWI0,
 	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
+	.div		= AT91_PMC_PCR_DIV8,
 };
 static struct clk twi1_clk = {
 	.name		= "twi1_clk",
 	.pid		= SAMA5D3_ID_TWI1,
 	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
+	.div		= AT91_PMC_PCR_DIV8,
 };
 static struct clk twi2_clk = {
 	.name		= "twi2_clk",
 	.pid		= SAMA5D3_ID_TWI2,
 	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
+	.div		= AT91_PMC_PCR_DIV8,
 };
 static struct clk mmc0_clk = {
 	.name		= "mci0_clk",
-- 
1.8.3.2

