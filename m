Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaLZIN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 03:13:59 -0500
Received: from www.osadl.org ([62.245.132.105]:51733 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbaLZIN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 03:13:57 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Helge Deller <deller@gmx.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-input@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH 4/13] incorrect use of init_completion fixup
Date: Fri, 26 Dec 2014 09:06:10 +0100
Message-Id: <1419581170-5182-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The successive init_completion calls should be reinit_completion calls.

patch against 3.19.0-rc1 linux-next

Acked-by: Helge Deller <deller@gmx.de>
Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/input/keyboard/hil_kbd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
index 610a8af..5b152f2 100644
--- a/drivers/input/keyboard/hil_kbd.c
+++ b/drivers/input/keyboard/hil_kbd.c
@@ -473,7 +473,7 @@ static int hil_dev_connect(struct serio *serio, struct serio_driver *drv)
 	if (error)
 		goto bail1;

-	init_completion(&dev->cmd_done);
+	reinit_completion(&dev->cmd_done);
 	serio_write(serio, 0);
 	serio_write(serio, 0);
 	serio_write(serio, HIL_PKT_CMD >> 8);
@@ -482,7 +482,7 @@ static int hil_dev_connect(struct serio *serio, struct serio_driver *drv)
 	if (error)
 		goto bail1;

-	init_completion(&dev->cmd_done);
+	reinit_completion(&dev->cmd_done);
 	serio_write(serio, 0);
 	serio_write(serio, 0);
 	serio_write(serio, HIL_PKT_CMD >> 8);
@@ -491,7 +491,7 @@ static int hil_dev_connect(struct serio *serio, struct serio_driver *drv)
 	if (error)
 		goto bail1;

-	init_completion(&dev->cmd_done);
+	reinit_completion(&dev->cmd_done);
 	serio_write(serio, 0);
 	serio_write(serio, 0);
 	serio_write(serio, HIL_PKT_CMD >> 8);
--
1.7.10.4

