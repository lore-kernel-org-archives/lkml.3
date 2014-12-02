Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbaLBRec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:34:32 -0500
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:55649 "EHLO
	resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932225AbaLBReb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:34:31 -0500
Date: Tue, 2 Dec 2014 11:34:28 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <htejun@gmail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        James.Bottomley@HansenPartnership.com
Subject: Re: Final per cpu consistency patch for -next or late in 3.19 merge
 period
In-Reply-To: <20141202171102.GC10918@htj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1412021133170.19228@gentwo.org>
References: <alpine.DEB.2.11.1411281229350.11435@gentwo.org> <20141202164024.GA10918@htj.dyndns.org> <alpine.DEB.2.11.1412021049580.13039@gentwo.org> <20141202171102.GC10918@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014, Tejun Heo wrote:

> Sure, I just wanna make sure we don't have dangling references to
> __get_cpu_var() which no longer exists.  There are also a couple
> places where comment text refers to it.  Let's please take care of
> them too.

And the last one: PARISC


From: Christoph Lameter <cl@linux.com>
Subject: parisc: Update comments refereing to __get_cpu_var

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

