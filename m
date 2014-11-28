Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaK1Sbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:31:32 -0500
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:47320 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968AbaK1SbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:31:24 -0500
Date: Fri, 28 Nov 2014 12:31:22 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <htejun@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Final per cpu consistency patch for -next or late in 3.19 merge
 period
Message-ID: <alpine.DEB.2.11.1411281229350.11435@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the final patch to remove __get_cpu_var. I checked -next and there
are no remaining uses of __get_cpu_var. So either merge this to -next or
wait until 3.19 late.

However, if we wait till 3.19 then I may have to do another pass if
people add more uses of __get_cpu_var and submit another patch.

From: Christoph Lameter <cl@linux.com>
Date: Tue, 29 Jul 2014 16:09:54 -0500
Subject: [PATCH] Remove __get_cpu_var and __raw_get_cpu_var macros

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
