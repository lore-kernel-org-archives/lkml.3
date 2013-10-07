Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab3JGRuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:50:51 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:55666 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754853Ab3JGRuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:50:46 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Oct 2013 13:50:46 EDT
Date: Mon, 07 Oct 2013 12:43:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] Add inline routine to free memory used in kobject name
Message-ID: <5252f2cd.33yoX1hUWLRsRUrq%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present, if one wants to free the memory allocation used for
a dev->kobj name, it is necessary to go quite deeply into the structure.
To avoid this much dependence on the structure details in driver
code, a new inline routine is created.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-save/include/linux/device.h
===================================================================
--- wireless-testing-save.orig/include/linux/device.h
+++ wireless-testing-save/include/linux/device.h
@@ -27,6 +27,7 @@
 #include <linux/ratelimit.h>
 #include <linux/uidgid.h>
 #include <asm/device.h>
+#include <linux/slab.h>
 
 struct device;
 struct device_private;
@@ -789,6 +790,11 @@ static inline const char *dev_name(const
 	return kobject_name(&dev->kobj);
 }
 
+static inline void dev_free_name(struct device *dev)
+{
+	kfree(dev->kobj.name);
+}
+
 extern __printf(2, 3)
 int dev_set_name(struct device *dev, const char *name, ...);
 
