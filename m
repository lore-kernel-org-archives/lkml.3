Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaB0LaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:30:19 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:60000 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaB0LaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:30:13 -0500
Date: Thu, 27 Feb 2014 17:00:05 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        kgdb-bugreport@lists.sourceforge.net, josh@joshtriplett.org
Subject: [PATCH 06/46] kernel: Include appropriate header file in
 kernel/debug/kdb/kdb_keyboard.c
Message-ID: <c8d6b1907e8f8452fae0b0f0b341f7e81ab20cfb.1393493276.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file kernel/debug/kdb/kdb_private.h in
kernel/debug/kdb/kdb_keyboard.c because it contains prototype definition
of functions defined in kernel/debug/kdb/kdb_keyboard.c.

This eliminates the following warning in
kernel/debug/kdb/kdb_keyboard.c:
kernel/debug/kdb/kdb_keyboard.c:199:6: warning: no previous prototype for ‘kdb_kbd_cleanup_state’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/debug/kdb/kdb_keyboard.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/debug/kdb/kdb_keyboard.c b/kernel/debug/kdb/kdb_keyboard.c
index 118527a..f1405da 100644
--- a/kernel/debug/kdb/kdb_keyboard.c
+++ b/kernel/debug/kdb/kdb_keyboard.c
@@ -14,6 +14,8 @@
 #include <linux/module.h>
 #include <linux/io.h>
 
+#include "kdb_private.h"
+
 /* Keyboard Controller Registers on normal PCs. */
 
 #define KBD_STATUS_REG		0x64	/* Status register (R) */
-- 
1.7.9.5

