Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab3LSPui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:50:38 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:50400 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612Ab3LSPue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:50:34 -0500
Message-Id: <20131219155031.080415447@linux.com>
Date: Thu, 19 Dec 2013 09:50:18 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 03/40] percpu: Replace __get_cpu_var with this_cpu_ptr
References: <20131219155015.443763038@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_percpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One case of using __get_cpu_var in the get_cpu_var macro
for address calculation.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/percpu.h
===================================================================
--- linux.orig/include/linux/percpu.h	2013-12-02 16:07:46.904713849 -0600
+++ linux/include/linux/percpu.h	2013-12-02 16:09:23.000000000 -0600
@@ -28,7 +28,7 @@
  */
 #define get_cpu_var(var) (*({				\
 	preempt_disable();				\
-	&__get_cpu_var(var); }))
+	this_cpu_ptr(&var); }))
 
 /*
  * The weird & is necessary because sparse considers (void)(var) to be

