Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbaG2L6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:58:51 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51676 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbaG2L6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:58:46 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/19] staging: comedi: amplc_pci230: remove PCI230_ADC_CONV
Date: Tue, 29 Jul 2014 12:58:16 +0100
Message-Id: <1406635107-27950-9-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro `PCI230_ADC_CONV` is never used.  Just remove it.  (At one
time, the value was written to the `PCI230_ADCSWTRIG` register to
trigger a conversion, but any value would do, and the driver no longer
uses that register to trigger conversions anyway.)

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 7983a0d..e6744a5 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -362,12 +362,6 @@
 #define PCI230_ADC_FIFOLEVEL_FULL	4096	/* FIFO size */
 
 /*
- * Value to write to ADCSWTRIG to trigger ADC conversion in software trigger
- * mode.  Can be anything.
- */
-#define PCI230_ADC_CONV			0xffff
-
-/*
  * PCI230+ EXTFUNC values.
  */
 /* Route EXTTRIG pin to external gate inputs. */
-- 
2.0.0

