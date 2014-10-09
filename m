Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaJITnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:43:41 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:59933 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaJITne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:43:34 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] regulator: Include err.h from consumer.h to fix build failure
Date: Thu,  9 Oct 2014 12:43:27 -0700
Message-Id: <1412883807-20825-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sh:sh2007_defconfig fails to build with the following error:

In file included from include/linux/regulator/machine.h:18:0,
                 from arch/sh/boards/board-sh2007.c:10:
include/linux/regulator/consumer.h: In function 'regulator_get_optional':
include/linux/regulator/consumer.h:271:2:
		error: implicit declaration of function 'ERR_PTR'
include/linux/err.h: At top level:
include/linux/err.h:23:35: error: conflicting types for 'ERR_PTR'
include/linux/regulator/consumer.h:271:9:
		note: previous implicit declaration of 'ERR_PTR' was here

Since consumer.h uses ERR_PTR, it should include err.h.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 include/linux/regulator/consumer.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index d347c80..f540b14 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -35,6 +35,8 @@
 #ifndef __LINUX_REGULATOR_CONSUMER_H_
 #define __LINUX_REGULATOR_CONSUMER_H_
 
+#include <linux/err.h>
+
 struct device;
 struct notifier_block;
 struct regmap;
-- 
1.9.1

