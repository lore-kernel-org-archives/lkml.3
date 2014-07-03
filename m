Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbaGCCR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:17:26 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:55351 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918AbaGCCRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:17:23 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH v2 1/3] staging: comedi: addi_apci_1564: move addi_watchdog.h include to addi_apci_1564.c
Date: Wed,  2 Jul 2014 21:16:39 -0500
Message-Id: <1404353799-28811-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404353739-28607-1-git-send-email-chase.southwood@gmail.com>
References: <1404353739-28607-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit aed3f9d (staging: comedi: addi_apci_1564: absorb apci1564_reset()) moved
the only use of addi_watchdog.h from hwdrv_apci1564.c to addi_apci_1564.c, but
left the include statement itself in the former file.  Move this include to the
file which actually uses it.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c | 2 --
 drivers/staging/comedi/drivers/addi_apci_1564.c           | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 4007fd2..7326f3a 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -21,8 +21,6 @@
  *
  */
 
-#include "../addi_watchdog.h"
-
 #define APCI1564_ADDRESS_RANGE				128
 
 /* Digital Input IRQ Function Selection */
diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index f71ee02..59786e7 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -4,6 +4,7 @@
 #include "../comedidev.h"
 #include "comedi_fc.h"
 #include "amcc_s5933.h"
+#include "addi_watchdog.h"
 
 #include "addi-data/addi_common.h"
 
-- 
2.0.1

