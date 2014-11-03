Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaKCDJE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 22:09:04 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:56358 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbaKCDIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 22:08:38 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [RFC RESEND 10/10] usb: Remove __init from early_dbgp_init() prototype
Date: Sun,  2 Nov 2014 21:07:57 -0600
Message-Id: <1414984077-9750-11-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414984077-9750-1-git-send-email-chris@rorvick.com>
References: <1414984077-9750-1-git-send-email-chris@rorvick.com>
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

