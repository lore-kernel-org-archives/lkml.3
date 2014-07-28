Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaG1LZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:25:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40901 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbaG1LZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:25:10 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <khilman@deeprootsystems.com>
CC: <linux@arm.linux.org.uk>, <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] ARM: davinci: board-da850-evm: Mark dcdc2 of TPS65070 as always_on
Date: Mon, 28 Jul 2014 14:24:37 +0300
Message-ID: <1406546678-797-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DCDC2 should not be turned off since it is powering the CPU among other
things.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/mach-davinci/board-da850-evm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 234c5bb091f5..77d8968336df 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -936,6 +936,7 @@ static struct regulator_init_data tps65070_regulator_data[] = {
 			.valid_ops_mask = (REGULATOR_CHANGE_VOLTAGE |
 				REGULATOR_CHANGE_STATUS),
 			.boot_on = 1,
+			.always_on = 1,
 		},
 		.num_consumer_supplies = ARRAY_SIZE(tps65070_dcdc2_consumers),
 		.consumer_supplies = tps65070_dcdc2_consumers,
-- 
2.0.2

