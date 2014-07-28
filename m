Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaG1MLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:11:17 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49031 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbaG1MJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:09:49 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] staging: comedi: amplc_pc236, amplc_pci236: get rid of bustype
Date: Mon, 28 Jul 2014 13:09:35 +0100
Message-Id: <1406549375-1864-8-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406549375-1864-1-git-send-email-abbotti@mev.co.uk>
References: <1406549375-1864-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `bustype` member of `struct pc236_board` variables is initialized,
but never used.  Remove it along with the enumerated constants
associated with it.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pc236.c  | 1 -
 drivers/staging/comedi/drivers/amplc_pc236.h  | 3 ---
 drivers/staging/comedi/drivers/amplc_pci236.c | 1 -
 3 files changed, 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index b95b877..875cc19 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -65,7 +65,6 @@ static int pc236_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 static const struct pc236_board pc236_boards[] = {
 	{
 		.name = "pc36at",
-		.bustype = isa_bustype,
 	},
 };
 
diff --git a/drivers/staging/comedi/drivers/amplc_pc236.h b/drivers/staging/comedi/drivers/amplc_pc236.h
index 37348f1..91d6d9c 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.h
+++ b/drivers/staging/comedi/drivers/amplc_pc236.h
@@ -25,11 +25,8 @@
 
 struct comedi_device;
 
-enum pc236_bustype { isa_bustype, pci_bustype };
-
 struct pc236_board {
 	const char *name;
-	enum pc236_bustype bustype;
 	void (*intr_update_cb)(struct comedi_device *dev, bool enable);
 	bool (*intr_chk_clr_cb)(struct comedi_device *dev);
 };
diff --git a/drivers/staging/comedi/drivers/amplc_pci236.c b/drivers/staging/comedi/drivers/amplc_pci236.c
index a7e7a6f..436aeba 100644
--- a/drivers/staging/comedi/drivers/amplc_pci236.c
+++ b/drivers/staging/comedi/drivers/amplc_pci236.c
@@ -90,7 +90,6 @@ static const struct pc236_board pc236_pci_board = {
 	.name = "pci236",
 	.intr_update_cb = pci236_intr_update_cb,
 	.intr_chk_clr_cb = pci236_intr_chk_clr_cb,
-	.bustype = pci_bustype,
 };
 
 static int pci236_auto_attach(struct comedi_device *dev,
-- 
2.0.0

