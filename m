Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab3BRW6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 17:58:04 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:38987 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512Ab3BRW6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 17:58:03 -0500
To: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] <linux/of_platform.h>: fix compilation warnings with DT disabled
Cc: vladimir.barinov@cogentembedded.com, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Date: Tue, 19 Feb 2013 02:58:25 +0300
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201302190258.25726.sergei.shtylyov@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following compilation warnings (in Simon Horman's renesas.git repo):

In file included from arch/arm/mach-shmobile/setup-r8a7779.c:24:0:
include/linux/of_platform.h:107:13: warning: ‘struct of_device_id’ declared
inside parameter list [enabled by default]
include/linux/of_platform.h:107:13: warning: its scope is only this definition
or declaration, which is probably not what you want [enabled by default]
include/linux/of_platform.h:107:13: warning: ‘struct device_node’ declared
inside parameter list [enabled by default]

<linux/of_platform.h> only #include's headers with definitions of the above
mentioned structures if CONFIG_OF_DEVICE=y but uses them even if not. One
solution is to move some #include's out of #ifdef CONFIG_OF_DEVICE and use
incomplete declarations for the rest of the structures where the #ifdef move
doesn't help...

Reported-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
Actually, it compiles eve without 'struct device_node' declared, I haven't
found the reason of this, so left it there...

 include/linux/of_platform.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux/include/linux/of_platform.h
===================================================================
--- linux.orig/include/linux/of_platform.h
+++ linux/include/linux/of_platform.h
@@ -11,9 +11,10 @@
  *
  */
 
-#ifdef CONFIG_OF_DEVICE
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
+
+#ifdef CONFIG_OF_DEVICE
 #include <linux/pm.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
@@ -100,7 +101,7 @@ extern int of_platform_populate(struct d
 
 #if !defined(CONFIG_OF_ADDRESS)
 struct of_dev_auxdata;
-struct device;
+struct device_node;
 static inline int of_platform_populate(struct device_node *root,
 					const struct of_device_id *matches,
 					const struct of_dev_auxdata *lookup,
