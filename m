Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab3AWMo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 07:44:29 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:54306 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab3AWMo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 07:44:28 -0500
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 3.8-rc4-nohz3] kvm: Add missing EXPORT_SYMBOL_GPL when CONFIG_KVM=m
Date: Wed, 23 Jan 2013 13:44:16 +0100
Message-Id: <1358945056-5390-1-git-send-email-sedat.dilek@gmail.com>
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
[ v3: Forgot my S-o-b. -dileks ]

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
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

