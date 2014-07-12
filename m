Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaGLXoq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 19:44:46 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:46371 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaGLXoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 19:44:44 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Dan Carpenter <dan.carpenter@oracle.com>,
        julia.lawall@lip6.fr
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers: tty: Fix use-after-free in pty_common_install
Date: Sun, 13 Jul 2014 01:44:00 +0200
Message-Id: <1405208640-3613-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140712164714.GA12148@kroah.com>
References: <20140712164714.GA12148@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2c964a2f "drivers: tty: Merge alloc_tty_struct and
initialize_tty_struct", I messed up the refactorization of
pty_common_install, causing use-after-free and NULL pointer derefs on
various error paths. This should fix it.

Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/tty/pty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index ac723e3..9bbdb1d 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -388,7 +388,7 @@ err_deinit_tty:
 	deinitialize_tty_struct(o_tty);
 	free_tty_struct(o_tty);
 err_put_module:
-	module_put(o_tty->driver->owner);
+	module_put(driver->other->owner);
 err:
 	kfree(ports[0]);
 	kfree(ports[1]);
-- 
1.9.2

