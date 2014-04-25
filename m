Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaDYJCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:02:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbaDYJCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:02:16 -0400
Date: Fri, 25 Apr 2014 11:02:13 +0200
From: Jean Delvare <jdelvare@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] tty: n_hdlc: Drop redundant error message
Message-ID: <20140425110213.44ff3018@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On initialization failure, an error message is already printed with
level KERN_ERR, no need to print another one with level KERN_INFO.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/n_hdlc.c |    4 ----
 1 file changed, 4 deletions(-)

--- linux-3.15-rc2.orig/drivers/tty/n_hdlc.c	2014-03-31 05:40:15.000000000 +0200
+++ linux-3.15-rc2/drivers/tty/n_hdlc.c	2014-04-25 10:41:32.532755760 +0200
@@ -952,8 +952,6 @@ static char hdlc_register_ok[] __initdat
 	KERN_INFO "N_HDLC line discipline registered.\n";
 static char hdlc_register_fail[] __initdata =
 	KERN_ERR "error registering line discipline: %d\n";
-static char hdlc_init_fail[] __initdata =
-	KERN_INFO "N_HDLC: init failure %d\n";
 
 static int __init n_hdlc_init(void)
 {
@@ -973,8 +971,6 @@ static int __init n_hdlc_init(void)
 	else
 		printk(hdlc_register_fail, status);
 
-	if (status)
-		printk(hdlc_init_fail, status);
 	return status;
 	
 }	/* end of init_module() */

-- 
Jean Delvare
SUSE L3 Support
