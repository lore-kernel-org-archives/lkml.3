Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaHQRb5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:31:57 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:59852
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094AbaHQRbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:31:55 -0400
Message-Id: <20140817173038.020385438@linux.com>
Date: Sun, 17 Aug 2014 12:30:56 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 33/35] [PATCH 34/36] percpu: Remove __this_cpu_ptr
References: <20140817173023.439660246@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0034-percpu-Remove-__this_cpu_ptr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __this_cpu_ptr macro is no longer in use so drop it.

Signed-off-by: Christoph Lameter <cl@linux.com>
---
 include/asm-generic/percpu.h | 3 ---
 1 file changed, 3 deletions(-)

Index: linux/include/linux/percpu-defs.h
===================================================================
--- linux.orig/include/linux/percpu-defs.h
+++ linux/include/linux/percpu-defs.h
@@ -257,9 +257,6 @@ do {									\
 #define __raw_get_cpu_var(var)	(*raw_cpu_ptr(&(var)))
 #define __get_cpu_var(var)	(*this_cpu_ptr(&(var)))
 
-/* keep until we have removed all uses of __this_cpu_ptr */
-#define __this_cpu_ptr(ptr)	raw_cpu_ptr(ptr)
-
 /*
  * Must be an lvalue. Since @var must be a simple identifier,
  * we force a syntax error here if it isn't.

