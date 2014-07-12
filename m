Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaGLWn0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 18:43:26 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:50870 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaGLWnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 18:43:25 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 1/2] staging: comedi: addi_apci_1564: driver no longer needs to include addi_common.h
Date: Sat, 12 Jul 2014 17:42:36 -0500
Message-Id: <1405204956-1559-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver no longer depends on anything in addi_common.h, save for a
few headers that it was including indirectly.  Remove the include of
addi_common.h and add the includes of <linux/interrupt.h>
and <linux/sched.h> directly.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi_apci_1564.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 1e25342..16f3b69 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -1,13 +1,13 @@
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
 
 #include "../comedidev.h"
 #include "comedi_fc.h"
 #include "amcc_s5933.h"
 #include "addi_watchdog.h"
 
-#include "addi-data/addi_common.h"
-
 struct apci1564_private {
 	unsigned int amcc_iobase;	/* base of AMCC I/O registers */
 	unsigned int mode1;		/* riding-edge/high level channels */
-- 
2.0.1

