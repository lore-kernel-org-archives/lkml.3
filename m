Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaBNUT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:19:28 -0500
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:53256
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851AbaBNUTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:19:25 -0500
Message-Id: <20140214201904.750129019@linux.com>
Date: Fri, 14 Feb 2014 14:18:49 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 08/48] percpu: Replace __get_cpu_var with this_cpu_ptr
References: <20140214201841.826179349@linux.com>
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
--- linux.orig/include/linux/percpu.h	2014-01-30 14:40:02.667473594 -0600
+++ linux/include/linux/percpu.h	2014-01-30 14:40:02.667473594 -0600
@@ -29,7 +29,7 @@
  */
 #define get_cpu_var(var) (*({				\
 	preempt_disable();				\
-	&__get_cpu_var(var); }))
+	this_cpu_ptr(&var); }))
 
 /*
  * The weird & is necessary because sparse considers (void)(var) to be

