Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbaEPL1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 07:27:44 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:65406 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932152AbaEPL1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 07:27:43 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] PM / runtime: Update documentation to reflect the current code flow
Date: Fri, 16 May 2014 13:44:32 +0200
Message-ID: <1820626.RvqOqaKi2q@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The runtime PM documentation in runtime_pm.txt has not been updated
after some changes to the system suspend and resume core code, so
update it to reflect the current code flow.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

This is independent of the "do not resume runtime-suspended devices" series.

Thanks!

---
 Documentation/power/runtime_pm.txt |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

Index: linux-pm/Documentation/power/runtime_pm.txt
===================================================================
--- linux-pm.orig/Documentation/power/runtime_pm.txt
+++ linux-pm/Documentation/power/runtime_pm.txt
@@ -665,15 +665,17 @@ The PM core does its best to reduce the
 the runtime PM and system suspend/resume (and hibernation) callbacks by carrying
 out the following operations:
 
-  * During system suspend it calls pm_runtime_get_noresume() and
-    pm_runtime_barrier() for every device right before executing the
-    subsystem-level .suspend() callback for it.  In addition to that it calls
-    __pm_runtime_disable() with 'false' as the second argument for every device
-    right before executing the subsystem-level .suspend_late() callback for it.
+  * During system suspend pm_runtime_get_noresume() is called for every device
+    right before executing the subsystem-level .prepare() callback for it and
+    pm_runtime_barrier() is called for every device right before executing the
+    subsystem-level .suspend() callback for it.  In addition to that the PM core
+    calls  __pm_runtime_disable() with 'false' as the second argument for every
+    device right before executing the subsystem-level .suspend_late() callback
+    for it.
 
-  * During system resume it calls pm_runtime_enable() and pm_runtime_put()
-    for every device right after executing the subsystem-level .resume_early()
-    callback and right after executing the subsystem-level .resume() callback
+  * During system resume pm_runtime_enable() and pm_runtime_put() are called for
+    every device right after executing the subsystem-level .resume_early()
+    callback and right after executing the subsystem-level .complete() callback
     for it, respectively.
 
 7. Generic subsystem callbacks

