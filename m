Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbaGYJI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:08:29 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:41155 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759260AbaGYJFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:05:20 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] staging: comedi: amplc_pc236: remove 'model' member
Date: Fri, 25 Jul 2014 10:04:53 +0100
Message-Id: <1406279098-8498-8-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
References: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `model` member of `struct pc236_board` is no longer used since the
code to remove manual configuration of PCI devices was removed.  Get rid
of it.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pc236.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 22d3b6f..129578f 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -82,20 +82,17 @@
  */
 
 enum pc236_bustype { isa_bustype, pci_bustype };
-enum pc236_model { pc36at_model, pci236_model };
 
 struct pc236_board {
 	const char *name;
 	unsigned short devid;
 	enum pc236_bustype bustype;
-	enum pc236_model model;
 };
 static const struct pc236_board pc236_boards[] = {
 #if DO_ISA
 	{
 		.name = "pc36at",
 		.bustype = isa_bustype,
-		.model = pc36at_model,
 	},
 #endif
 #if DO_PCI
@@ -103,7 +100,6 @@ static const struct pc236_board pc236_boards[] = {
 		.name = "pci236",
 		.devid = PCI_DEVICE_ID_AMPLICON_PCI236,
 		.bustype = pci_bustype,
-		.model = pci236_model,
 	},
 #endif
 };
-- 
2.0.0

