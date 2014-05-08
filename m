Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbaEHQZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:25:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47928 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753156AbaEHQZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:25:24 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, arnd@arndb.de, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: arizona-micsupp: Add missing #include
Date: Thu,  8 May 2014 17:17:38 +0100
Message-Id: <1399565858-32480-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of.h is presently being included through asm-generic/gpio.h so will not
be included on some architectures, causing implicit declaration errors
for of_get_child_by_name, of_parse_phandle and of_node_put.

This patch adds the direct include that should be there.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-micsupp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index b80ebbe..ce9aca5 100644
--- a/drivers/regulator/arizona-micsupp.c
+++ b/drivers/regulator/arizona-micsupp.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/err.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
-- 
1.7.2.5

