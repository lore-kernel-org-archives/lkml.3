Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144AbaLBVYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:24:44 -0500
Received: from resqmta-ch2-07v.sys.comcast.net ([69.252.207.39]:57311 "EHLO
	resqmta-ch2-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932886AbaLBVYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:24:41 -0500
Message-Id: <20141202212439.697171435@linux.com>
Date: Tue, 02 Dec 2014 15:24:30 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] Remove __get_cpu_var and __raw_get_cpu_var macros
References: <20141202212429.996456533@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0033-Remove-__get_cpu_var-and-__raw_get_cpu_var-macros-on.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No user is left in the kernel source tree. Therefore we can
drop the definitions.

This is the final merge of the transition away from __get_cpu_var.
After this patch the kernel will not build if anyone uses __get_cpu_var.

Signed-off-by: Christoph Lameter <cl@linux.com>
---
 include/asm-generic/percpu.h | 5 -----
 1 file changed, 5 deletions(-)

Index: linux/include/linux/percpu-defs.h
===================================================================
--- linux.orig/include/linux/percpu-defs.h
+++ linux/include/linux/percpu-defs.h
@@ -254,8 +254,6 @@ do {									\
 #endif	/* CONFIG_SMP */
 
 #define per_cpu(var, cpu)	(*per_cpu_ptr(&(var), cpu))
-#define __raw_get_cpu_var(var)	(*raw_cpu_ptr(&(var)))
-#define __get_cpu_var(var)	(*this_cpu_ptr(&(var)))
 
 /*
  * Must be an lvalue. Since @var must be a simple identifier,

