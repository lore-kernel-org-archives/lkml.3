Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaGMB10 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 21:27:26 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45558 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbaGMB1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 21:27:23 -0400
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Lidza Louina <lidza.louina@gmail.com>
Cc: Mark Hounschell <markh@compro.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH] dgnc: DGNC_VERIFY_BOARD macro in do while block
Date: Sat, 12 Jul 2014 18:26:39 -0700
Message-Id: <1405214799-2189-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enclose the body of the multi-statement DGNC_VERIFY_BOARD macro inside a
do - while block as per Documentation/CodingStyle.  Fixes 1 error found
by checkpatch.pl.

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/staging/dgnc/dgnc_sysfs.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_sysfs.c b/drivers/staging/dgnc/dgnc_sysfs.c
index 0f0e8fc..3f321bb 100644
--- a/drivers/staging/dgnc/dgnc_sysfs.c
+++ b/drivers/staging/dgnc/dgnc_sysfs.c
@@ -150,15 +150,17 @@ void dgnc_remove_driver_sysfiles(struct pci_driver *dgnc_driver)
 }
 
 
-#define DGNC_VERIFY_BOARD(p, bd)			\
-	if (!p)						\
-		return 0;				\
-							\
-	bd = dev_get_drvdata(p);			\
-	if (!bd || bd->magic != DGNC_BOARD_MAGIC)	\
-		return 0;				\
-	if (bd->state != BOARD_READY)			\
-		return 0;				\
+#define DGNC_VERIFY_BOARD(p, bd)				\
+	do {							\
+		if (!p)						\
+			return 0;				\
+								\
+		bd = dev_get_drvdata(p);			\
+		if (!bd || bd->magic != DGNC_BOARD_MAGIC)	\
+			return 0;				\
+		if (bd->state != BOARD_READY)			\
+			return 0;				\
+	} while (0)
 
 
 
-- 
2.0.1

