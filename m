Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbaLBVYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:24:54 -0500
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:49596 "EHLO
	resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932692AbaLBVYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:24:43 -0500
Message-Id: <20141202212440.031271472@linux.com>
Date: Tue, 02 Dec 2014 15:24:33 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 4/4] parisc: Update comments refereing to __get_cpu_var
References: <20141202212429.996456533@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=parisc_update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__get_cpu_var was removed. Update comments to refer to
this_cpu_ptr() instead.

Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/parisc/lib/fixup.S
===================================================================
--- linux.orig/arch/parisc/lib/fixup.S
+++ linux/arch/parisc/lib/fixup.S
@@ -38,14 +38,14 @@
 	LDREGX \t2(\t1),\t2 
 	addil LT%exception_data,%r27
 	LDREG RT%exception_data(%r1),\t1
-	/* t1 = &__get_cpu_var(exception_data) */
+	/* t1 = this_cpu_ptr(&exception_data) */
 	add,l \t1,\t2,\t1
 	/* t1 = t1->fault_ip */
 	LDREG EXCDATA_IP(\t1), \t1
 	.endm
 #else
 	.macro  get_fault_ip t1 t2
-	/* t1 = &__get_cpu_var(exception_data) */
+	/* t1 = this_cpu_ptr(&exception_data) */
 	addil LT%exception_data,%r27
 	LDREG RT%exception_data(%r1),\t2
 	/* t1 = t2->fault_ip */

