Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab3AWNPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 08:15:22 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:58735 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab3AWNPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:15:15 -0500
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 3.8-rc4-nohz3] kvm: Add missing EXPORT_SYMBOL when CONFIG_KVM=m
Date: Wed, 23 Jan 2013 14:15:05 +0100
Message-Id: <1358946905-13320-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_KVM=m my build with 3.8-rc4-nohz3 breaks like this:

ERROR: "guest_enter" [arch/x86/kvm/kvm.ko] undefined!
ERROR: "guest_exit" [arch/x86/kvm/kvm.ko] undefined!

Fix this by adding the missing EXPORT_SYMBOL for guest_enter() and
guest_exit() in kernel/context_tracking.c as suggested by Frederic.

This issue was introduced with commit 8eebafe9be58 ("kvm: Prepare to
add generic guest entry/exit callbacks").

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 kernel/context_tracking.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index bbb2c2c..950f30a 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -111,14 +111,16 @@ void guest_enter(void)
 	else
 		__guest_enter();
 }
+EXPORT_SYMBOL(guest_enter);
 
 void guest_exit(void)
-{
+{i
 	if (vtime_accounting_enabled())
 		vtime_guest_exit(current);
 	else
 		__guest_exit();
 }
+EXPORT_SYMBOL(guest_exit);
 #endif
 
 
-- 
1.8.1.1

