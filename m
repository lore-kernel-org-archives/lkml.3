Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbaFBI6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:58:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38654 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979AbaFBI6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:58:18 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] mfd: arizona: Use num_core_supplies in arizona_dev_exit
Date: Mon,  2 Jun 2014 09:50:42 +0100
Message-Id: <1401699043-16835-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1401699043-16835-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1401699043-16835-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we call regulator_bulk_disable with
ARRAY_SIZE(arizona->core_supplies), however this array may be larger
than the number of supplies actually used by the chip we are dealing
with. Use the provided num_core_supplies member instead, so that we only
disable supplies which actually exist.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 7678e84..51c0110 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -1039,7 +1039,7 @@ int arizona_dev_exit(struct arizona *arizona)
 	if (arizona->pdata.reset)
 		gpio_set_value_cansleep(arizona->pdata.reset, 0);
 
-	regulator_bulk_disable(ARRAY_SIZE(arizona->core_supplies),
+	regulator_bulk_disable(arizona->num_core_supplies,
 			       arizona->core_supplies);
 	return 0;
 }
-- 
1.7.2.5

