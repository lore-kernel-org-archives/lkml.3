Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343AbaI2EuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 00:50:08 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:60057 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbaI2Eto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 00:49:44 -0400
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [RFC RESEND 10/10] usb: Remove __init from early_dbgp_init() prototype
Date: Sun, 28 Sep 2014 23:48:58 -0500
Message-Id: <1411966138-3053-11-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411966138-3053-1-git-send-email-chris@rorvick.com>
References: <1411966138-3053-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specifying these attributes in both the prototype and the function
definition is unnecessary and could cause confusion or bugs if they are
inconsistent.  As such, __init should only be specified at the function
definition.

Keith Owens suggested this as a janitorial task on LKML several years
ago:

  https://lkml.org/lkml/2006/1/14/305

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 include/linux/usb/ehci-dbgp.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/usb/ehci-dbgp.h b/include/linux/usb/ehci-dbgp.h
index 796c1cd..7344d9e 100644
--- a/include/linux/usb/ehci-dbgp.h
+++ b/include/linux/usb/ehci-dbgp.h
@@ -43,8 +43,7 @@ struct ehci_dbg_port {
 };
 
 #ifdef CONFIG_EARLY_PRINTK_DBGP
-#include <linux/init.h>
-extern int __init early_dbgp_init(char *s);
+extern int early_dbgp_init(char *s);
 extern struct console early_dbgp_console;
 #endif /* CONFIG_EARLY_PRINTK_DBGP */
 
-- 
1.9.3

