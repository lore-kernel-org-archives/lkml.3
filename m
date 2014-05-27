Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaE0QfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:35:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37419 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292AbaE0QfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:35:11 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, arnd@arndb.de, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v2] regulator: arizona-ldo1: add missing #include
Date: Tue, 27 May 2014 17:27:34 +0100
Message-Id: <1401208054-16955-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 2cce4be9e6b8 "regulator: arizona-ldo1: Add processing of init_data
from device tree" added a call to of_get_child_by_name() but
did not add an #include to the header file declaring that function.

I got a build error when doing randconfig testing on this, which
is fixed by this patch to include of.h.

drivers/regulator/arizona-ldo1.c:192:2: error: implicit declaration of function 'of_get_child_by_name' [-Werror=implicit-function-declaration]
drivers/regulator/arizona-ldo1.c:193:2: error: implicit declaration of function 'of_parse_phandle' [-Werror=implicit-function-declaration]
drivers/regulator/arizona-ldo1.c:213:2: error: implicit declaration of function 'of_node_put' [-Werror=implicit-function-declaration]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---

Hi,

Sorry forgot I was supposed to add my sign off when sending
other peoples patches. Here it is with my sign off added.

Thanks,
Charles

 drivers/regulator/arizona-ldo1.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index d3787e1..04f262a 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
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

