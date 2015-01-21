Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbbAUXGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 18:06:42 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:56034 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbbAUXGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 18:06:32 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: ux500: Move struct
Date: Thu, 22 Jan 2015 00:09:41 +0100
Message-Id: <1421881782-23716-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move struct ab8500_ext_regulator_cfg to  the only file that is now used in.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/regulator/ab8500-ext.c   |    6 ++++++
 include/linux/regulator/ab8500.h |    5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index 84c1ee3..a40c701 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -25,6 +25,12 @@
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/regulator/ab8500.h>
 
+
+/* AB8500 external regulators */
+struct ab8500_ext_regulator_cfg {
+	bool hwreq; /* requires hw mode or high power mode */
+};
+
 /**
  * struct ab8500_ext_regulator_info - ab8500 regulator information
  * @dev: device pointer
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index d8ecefa..802529b 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -300,11 +300,6 @@ enum ab8540_regulator_reg {
 	AB8540_NUM_REGULATOR_REGISTERS,
 };
 
-/* AB8500 external regulators */
-struct ab8500_ext_regulator_cfg {
-	bool hwreq; /* requires hw mode or high power mode */
-};
-
 enum ab8500_ext_regulator_id {
 	AB8500_EXT_SUPPLY1,
 	AB8500_EXT_SUPPLY2,
-- 
1.7.10.4

