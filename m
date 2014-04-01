Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaDAG35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 02:29:57 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:62868 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaDAG34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 02:29:56 -0400
From: Anders Darander <anders.darander@gmail.com>
To: gregkh@linuxfoundation.org
Cc: marek.belisko@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Anders Darander <anders.darander@gmail.com>
Subject: [PATCH] Staging: ft1000-usb: wrap macros in do while
Date: Tue,  1 Apr 2014 08:29:39 +0200
Message-Id: <1396333780-10228-1-git-send-email-anders.darander@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issue by wrapping the macro in a do {} while (0).

Signed-off-by: Anders Darander <anders.darander@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index 2575d0d..28f07a7 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -32,17 +32,20 @@
 
 
 #define seq_putx(m, message, size, var) \
-	seq_printf(m, message);	\
-	for (i = 0; i < (size - 1); i++) \
-		seq_printf(m, "%02x:", var[i]); \
-	seq_printf(m, "%02x\n", var[i])
+	do { \
+		seq_printf(m, message);	\
+		for (i = 0; i < (size - 1); i++) \
+			seq_printf(m, "%02x:", var[i]); \
+		seq_printf(m, "%02x\n", var[i]);	\
+	} while (0)
 
 #define seq_putd(m, message, size, var) \
-	seq_printf(m, message); \
-	for (i = 0; i < (size - 1); i++) \
-		seq_printf(m, "%d.", var[i]); \
-	seq_printf(m, "%d\n", var[i])
-
+	do { \
+		seq_printf(m, message); \
+		for (i = 0; i < (size - 1); i++) \
+			seq_printf(m, "%d.", var[i]); \
+		seq_printf(m, "%d\n", var[i]);	      \
+	} while (0)
 
 #define FTNET_PROC init_net.proc_net
 
-- 
1.9.1

