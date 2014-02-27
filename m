Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaB0LoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:44:09 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:38821 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaB0LoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:44:07 -0500
Date: Thu, 27 Feb 2014 17:11:51 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        josh@joshtriplett.org
Subject: [PATCH 13/46] kernel: Move prototype declaration to header file
 kernel/locking/lockdep_internals.h
Message-ID: <785df84f015e4aa57532c03149113ce55894f7f8.1393493276.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declaration of functions to header file
kernel/locking/lockdep_internals.h because they are used by more than
one file.

This eliminates the following warning in kernel/locking/lockdep.c:
kernel/locking/lockdep.c:2560:6: warning: no previous prototype for ‘trace_hardirqs_on_caller’ [-Wmissing-prototypes]
kernel/locking/lockdep.c:2613:6: warning: no previous prototype for ‘trace_hardirqs_off_caller’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/locking/lockdep_internals.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/locking/lockdep_internals.h b/kernel/locking/lockdep_internals.h
index 4f560cf..81390ab 100644
--- a/kernel/locking/lockdep_internals.h
+++ b/kernel/locking/lockdep_internals.h
@@ -70,6 +70,9 @@ enum {
 extern struct list_head all_lock_classes;
 extern struct lock_chain lock_chains[];
 
+void trace_hardirqs_on_caller(unsigned long ip);
+void trace_hardirqs_off_caller(unsigned long ip);
+
 #define LOCK_USAGE_CHARS (1+LOCK_USAGE_STATES/2)
 
 extern void get_usage_chars(struct lock_class *class,
-- 
1.7.9.5

