Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab3JCP1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:27:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50920 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754522Ab3JCP1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:27:21 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH v3] mfd: arizona: Correct handling of device tree gpio defaults
Date: Thu,  3 Oct 2013 16:16:01 +0100
Message-Id: <1380813361-15400-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When setting GPIO defaults we are required to make a distinction
between writing 0x0000 to the registers and leaving them untouched.

When we receive between 0x0000 and 0xFFFF (inclusive) from either
Platform Data or Device Tree, we should write the provided
configuration to the device. Conversely, when we receive >0xFFFF we
should leave the device configuration at its default setting.

This patch fixes a bug and ensures that configuration 0x0000 isn't
mistakenly written when the intention was to keep the default one.

Reported-by: Heather Lomond <heather.lomond@wolfsonmicro.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---

Hi,

Sorry, your explanation is certainly fine with me.

Thanks,
Charles

 drivers/mfd/arizona-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 5ac3aa4..e13355b 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -540,7 +540,7 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
 		for (i = 0; i < ARRAY_SIZE(arizona->pdata.gpio_defaults); i++) {
 			if (arizona->pdata.gpio_defaults[i] > 0xffff)
 				arizona->pdata.gpio_defaults[i] = 0;
-			if (arizona->pdata.gpio_defaults[i] == 0)
+			else if (arizona->pdata.gpio_defaults[i] == 0)
 				arizona->pdata.gpio_defaults[i] = 0x10000;
 		}
 	} else {
-- 
1.7.2.5

