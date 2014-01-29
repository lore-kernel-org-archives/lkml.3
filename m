Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaA2KKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 05:10:05 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:50651 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaA2KKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 05:10:02 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, stable@vger.kernel.org,
        Andrea Adami <andrea.adami@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [PATCH] mfd: include all drivers in subsystem menu
Date: Wed, 29 Jan 2014 11:09:53 +0100
Message-Id: <1390990193-3064-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is currently not possible to select the SA1100 or Vexpress
drivers in the MFD subsystem, because the menu for the entire
subsystem ends before these options are presented.

Move the main menu closing and the endif for HAS_IOMEM to the
end of the file so these are selectable again.

Cc: stable@vger.kernel.org
Cc: Andrea Adami <andrea.adami@gmail.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 49bb445d846a..17004a61fdd5 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1193,9 +1193,6 @@ config MFD_STW481X
 	  in various ST Microelectronics and ST-Ericsson embedded
 	  Nomadik series.
 
-endmenu
-endif
-
 menu "Multimedia Capabilities Port drivers"
 	depends on ARCH_SA1100
 
@@ -1226,3 +1223,6 @@ config VEXPRESS_CONFIG
 	help
 	  Platform configuration infrastructure for the ARM Ltd.
 	  Versatile Express.
+
+endmenu
+endif
-- 
1.8.5.3

