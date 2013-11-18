Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab3KRTrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:47:13 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:47833 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab3KRTrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 14:47:10 -0500
Message-ID: <1384804015.4307.11.camel@haakon3.risingtidesystems.com>
Subject: Re: linux-next: Tree for Nov 15 (target_core_mod)
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>, kmo@daterainc.com,
        Tejun Heo <tj@kernel.org>
Date: Mon, 18 Nov 2013 11:46:55 -0800
In-Reply-To: <52865CB7.3070608@infradead.org>
References: <20131115162455.b45631434f6417b221f2a4d5@canb.auug.org.au>
	 <52865CB7.3070608@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-15 at 09:41 -0800, Randy Dunlap wrote:
> On 11/14/13 21:24, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Please do *not* add any v3.14 material to linux-next until after
> > v3.13-rc1 is released.
> > 
> > Changes since 20131114:
> > 
> 
> 
> on i386:
> 
> 
> ERROR: "percpu_ref_cancel_init" [drivers/target/target_core_mod.ko] undefined!
> ERROR: "percpu_ref_kill_and_confirm" [drivers/target/target_core_mod.ko] undefined!
> ERROR: "percpu_ref_init" [drivers/target/target_core_mod.ko] undefined!
> 
> 
> Full randconfig file is attached.
> 

Mmmm, confirmed that lib/Makefile not including percpu-refcount.o in
obj-y is the problem here..  (CC'ing Tejun + Kent).

Applying the following patch to target-pending/for-next now..

--nab

diff --git a/lib/Makefile b/lib/Makefile
index f3bb2cb..eaa946d 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -26,7 +26,7 @@ obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
         bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
         gcd.o lcm.o list_sort.o uuid.o flex_array.o iovec.o clz_ctz.o \
         bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o \
-        percpu_ida.o
+        percpu-refcount.o percpu_ida.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
 obj-y += kstrtox.o

