Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbaLBRdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:33:18 -0500
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:59792 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbaLBRdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:33:17 -0500
Date: Tue, 2 Dec 2014 11:33:15 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <htejun@gmail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: Final per cpu consistency patch for -next or late in 3.19 merge
 period
In-Reply-To: <20141202171102.GC10918@htj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1412021131350.19228@gentwo.org>
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

Here is the ia64 patch:


From: Christoph Lameter <cl@linux.com>
Subject: ia64: Update comment that references __get_cpu_var

__get_cpu_var was removed. Update the comments.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/ia64/include/asm/percpu.h
===================================================================
--- linux.orig/arch/ia64/include/asm/percpu.h
+++ linux/arch/ia64/include/asm/percpu.h
@@ -35,8 +35,8 @@ extern void *per_cpu_init(void);

 /*
  * Be extremely careful when taking the address of this variable!  Due to virtual
- * remapping, it is different from the canonical address returned by __get_cpu_var(var)!
- * On the positive side, using __ia64_per_cpu_var() instead of __get_cpu_var() is slightly
+ * remapping, it is different from the canonical address returned by this_cpu_ptr(&var)!
+ * On the positive side, using __ia64_per_cpu_var() instead of this_cpu_ptr() is slightly
  * more efficient.
  */
 #define __ia64_per_cpu_var(var) (*({					\
