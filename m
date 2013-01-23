Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab3AWMlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 07:41:12 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:60114 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab3AWMlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 07:41:11 -0500
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 3.8-rc4-nohz3] kvm: Add missing EXPORT_SYMBOL_GPL when CONFIG_KVM=m
Date: Wed, 23 Jan 2013 13:40:59 +0100
Message-Id: <1358944859-5299-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_KVM=m my build with 3.8-rc4-nohz3 breaks like this:

ERROR: "guest_enter" [arch/x86/kvm/kvm.ko] undefined!
ERROR: "guest_exit" [arch/x86/kvm/kvm.ko] undefined!

Fix this by adding the missing EXPORT_SYMBOL_GPL for guest_enter() and
guest_exit() in kernel/context_tracking.c as suggested by Frederic.

This issue was introduced with commit 8eebafe9be58 ("kvm: Prepare to
add generic guest entry/exit callbacks").

[ v2: Add reference to culprit commit. -dileks ]
---
 kernel/context_tracking.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index bbb2c2c..00403e6 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -111,6 +111,7 @@ void guest_enter(void)
 	else
 		__guest_enter();
 }
+EXPORT_SYMBOL_GPL(guest_enter);
 
 void guest_exit(void)
 {
@@ -119,6 +120,7 @@ void guest_exit(void)
 	else
 		__guest_exit();
 }
+EXPORT_SYMBOL_GPL(guest_exit);
 #endif
 
 
-- 
1.8.1.1

