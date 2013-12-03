Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab3LCXjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:39:03 -0500
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:53407 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754638Ab3LCXiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:38:54 -0500
Message-Id: <20131203233246.455803820@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 17:32:35 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 03/41] percpu: Replace __get_cpu_var with this_cpu_ptr
References: <20131203233232.928771708@linux.com>
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

