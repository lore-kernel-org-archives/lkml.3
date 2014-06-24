Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaFXR3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:29:08 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:37512 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaFXR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:28:19 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 4/6] include/linux/phonedev.h: Remove unused header
Date: Tue, 24 Jun 2014 19:27:33 +0200
Message-Id: <1403630855-29186-5-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403630855-29186-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1403630855-29186-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header file include/linux/phonedev.h does not seem to be used
anywhere. It was orphaned by 7326446c "Staging: remove telephony
drivers". Remove it.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/phonedev.h | 25 -------------------------
 1 file changed, 25 deletions(-)
 delete mode 100644 include/linux/phonedev.h

diff --git a/include/linux/phonedev.h b/include/linux/phonedev.h
deleted file mode 100644
index 4269de9..0000000
--- a/include/linux/phonedev.h
+++ /dev/null
@@ -1,25 +0,0 @@
-#ifndef __LINUX_PHONEDEV_H
-#define __LINUX_PHONEDEV_H
-
-#include <linux/types.h>
-
-#ifdef __KERNEL__
-
-#include <linux/poll.h>
-
-struct phone_device {
-	struct phone_device *next;
-	const struct file_operations *f_op;
-	int (*open) (struct phone_device *, struct file *);
-	int board;		/* Device private index */
-	int minor;
-};
-
-extern int phonedev_init(void);
-#define PHONE_MAJOR	100
-extern int phone_register_device(struct phone_device *, int unit);
-#define PHONE_UNIT_ANY	-1
-extern void phone_unregister_device(struct phone_device *);
-
-#endif
-#endif
-- 
1.9.2

