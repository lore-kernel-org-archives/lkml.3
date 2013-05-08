Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab3EHSO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:14:29 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:63443 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab3EHSOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:14:25 -0400
Date: Thu, 9 May 2013 02:14:15 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, alan@linux.intel.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] vt: delete unneeded function unbind_con_driver
Message-ID: <20130508181415.GF12344@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, jslaby@suse.cz, alan@linux.intel.com,
	airlied@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there is no place use unbind_con_driver,
and we can achieve unbind_con_driver's function
with do_unbind_con_driver easily, so just delete
it to reduce code size and duplication.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/tty/vt/vt.c     | 28 ----------------------------
 include/linux/vt_kern.h |  2 --
 2 files changed, 30 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index a422322..164cbef 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3116,34 +3116,6 @@ static int con_is_graphics(const struct consw *csw, int first, int last)
 	return retval;
 }
 
-/**
- * unbind_con_driver - unbind a console driver
- * @csw: pointer to console driver to unregister
- * @first: first in range of consoles that @csw should be unbound from
- * @last: last in range of consoles that @csw should be unbound from
- * @deflt: should next bound console driver be default after @csw is unbound?
- *
- * To unbind a driver from all possible consoles, pass 0 as @first and
- * %MAX_NR_CONSOLES as @last.
- *
- * @deflt controls whether the console that ends up replacing @csw should be
- * the default console.
- *
- * RETURNS:
- * -ENODEV if @csw isn't a registered console driver or can't be unregistered
- * or 0 on success.
- */
-int unbind_con_driver(const struct consw *csw, int first, int last, int deflt)
-{
-	int retval;
-
-	console_lock();
-	retval = do_unbind_con_driver(csw, first, last, deflt);
-	console_unlock();
-	return retval;
-}
-EXPORT_SYMBOL(unbind_con_driver);
-
 /* unlocked version of unbind_con_driver() */
 int do_unbind_con_driver(const struct consw *csw, int first, int last, int deflt)
 {
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index e8d6571..adc7ff5 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -133,8 +133,6 @@ void change_console(struct vc_data *new_vc);
 void reset_vc(struct vc_data *vc);
 extern int do_unbind_con_driver(const struct consw *csw, int first, int last,
 			     int deflt);
-extern int unbind_con_driver(const struct consw *csw, int first, int last,
-			     int deflt);
 int vty_init(const struct file_operations *console_fops);
 
 static inline bool vt_force_oops_output(struct vc_data *vc)
-- 
1.7.12.4.dirty
