Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab3JCK4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:56:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33309 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740Ab3JCK4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:56:21 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Correct handling of device tree gpio defaults
Date: Thu,  3 Oct 2013 11:42:16 +0100
Message-Id: <1380796936-1174-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intention is that all out of range values should cause the chips
default settings to be used and a value of zero should be treated
literally. Currently all out of range values will hit the second if and
be treated as a literal zero. This patch adds an else to fix this issue.

Reported-by: Heather Lomond <heather.lomond@wolfsonmicro.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
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

