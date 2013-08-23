Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3HWTCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:02:17 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:46522 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755916Ab3HWTCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:02:14 -0400
Message-ID: <00000140ac8e298a-4146b3e3-826e-4eb4-b523-ab35b82242d5-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Fri, 23 Aug 2013 19:02:13 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv 03/16] Coccinelle script for __get_cpu_var conversion
References: <20130823190135.726207430@linux.com>
X-SES-Outgoing: 2013.08.23-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Much of the work was done by this coccinelle script.

Wont catch everything (since coccinelle aborts when it no longer can make
sense out of macros, sigh) but it covers a lot of ground.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/scripts/coccinelle/convert/__get_cpu_var.cocci
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/scripts/coccinelle/convert/__get_cpu_var.cocci	2013-08-22 14:41:13.976518846 -0500
@@ -0,0 +1,70 @@
+// Convert all &__get_cpu_var to this_cpu_ptr
+//
+// _get_cpu_var is defined as:
+//
+// #define __get_cpu_var(var) (*this_cpu_ptr(&(var)))
+//
+//&__get_cpu_var() is therefore
+//
+//	this_cpu_ptr(&var);
+//
+// The use of this_cpu_ptr() instead of __get_cpu_var clarifies
+// that we are relocating a per cpu offset and that there are
+// no get/put semantics involved.
+//
+//
+// Convert all &__get_cpu_vars (and also related functions)
+// to this_cpu_ptr(). Multiple transformations are provided
+// to be able to beautify the source a bit.
+//
+// Christoph Lameter <cl@linux.com> August 20, 2013
+//
+
+@A@ expression E; @@
+
+...
+-(&__get_cpu_var(E))
++this_cpu_ptr(&E)
+...
+
+@B@ expression E; @@
+
+...
+-(&__raw_get_cpu_var(E))
++__this_cpu_ptr(&E)
+...
+
+@C@ expression E; @@
+
+...
+-&__get_cpu_var(E)
++this_cpu_ptr(&E)
+...
+
+@D@ expression E; @@
+
+...
+-&__raw_get_cpu_var(E)
++__this_cpu_ptr(&E)
+...
+
+@A2@ expression E; @@
+
+-(&__get_cpu_var(E))
++this_cpu_ptr(&E)
+
+@B2@ expression E; @@
+
+-(&__raw_get_cpu_var(E))
++__this_cpu_ptr(&E)
+
+@C2@ expression E; @@
+
+-&__get_cpu_var(E)
++this_cpu_ptr(&E)
+
+@D2@ expression E; @@
+
+-&__raw_get_cpu_var(E)
++__this_cpu_ptr(&E)
+

