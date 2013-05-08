Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288Ab3EHSO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:14:56 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34422 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729Ab3EHSOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:14:54 -0400
Date: Thu, 9 May 2013 02:14:44 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, alan@linux.intel.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] vt: delete unneeded function unregister_con_driver
Message-ID: <20130508181444.GJ12344@udknight>
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

Now there is no place use unregister_con_driver,
and we can achieve unregister_con_driver's function
with unregister_con_driver easily, so just delete it
to reduce code size and duplication.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/tty/vt/vt.c     | 13 +------------
 include/linux/console.h |  1 -
 2 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 8f4a71a..405e1c9 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3545,7 +3545,7 @@ err:
 
 
 /**
- * unregister_con_driver - unregister console driver from console layer
+ * do_unregister_con_driver - unregister console driver from console layer
  * @csw: console driver
  *
  * DESCRIPTION: All drivers that registers to the console layer must
@@ -3555,17 +3555,6 @@ err:
  *
  * The driver must unbind first prior to unregistration.
  */
-int unregister_con_driver(const struct consw *csw)
-{
-	int retval;
-
-	console_lock();
-	retval = do_unregister_con_driver(csw);
-	console_unlock();
-	return retval;
-}
-EXPORT_SYMBOL(unregister_con_driver);
-
 int do_unregister_con_driver(const struct consw *csw)
 {
 	int i, retval = -ENODEV;
diff --git a/include/linux/console.h b/include/linux/console.h
index c2b2d45..cbe59c3 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -75,7 +75,6 @@ extern const struct consw newport_con;	/* SGI Newport console  */
 extern const struct consw prom_con;	/* SPARC PROM console */
 
 int con_is_bound(const struct consw *csw);
-int unregister_con_driver(const struct consw *csw);
 int do_unregister_con_driver(const struct consw *csw);
 int do_take_over_console(const struct consw *sw, int first, int last, int deflt);
 void give_up_console(const struct consw *sw);
-- 
1.7.12.4.dirty
