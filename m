Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab3EWFrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 01:47:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57155 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab3EWFrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 01:47:00 -0400
Message-ID: <519DAD21.2050608@infradead.org>
Date: Wed, 22 May 2013 22:46:09 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH mainline] lib: make iovec obj instead of lib
References: <20130522234213.254ED31C6DC@corp2gmr1-1.hot.corp.google.com>
In-Reply-To: <20130522234213.254ED31C6DC@corp2gmr1-1.hot.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when CONFIG_VMWARE_VMCI=m:

ERROR: "memcpy_toiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!
ERROR: "memcpy_fromiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!

Changing iovec.o from lib-y to obj-y fixes the build errors.

---
From: Randy Dunlap <rdunlap@infradead.org>

Fix build error io vmw_vmci.ko by chaning iovec.o from lib-y to
obj-y.

ERROR: "memcpy_toiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!
ERROR: "memcpy_fromiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 lib/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- mmotm-2013-0522-1640.orig/lib/Makefile
+++ mmotm-2013-0522-1640/lib/Makefile
@@ -9,7 +9,7 @@ endif
 
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o timerqueue.o\
-	 idr.o int_sqrt.o extable.o iovec.o \
+	 idr.o int_sqrt.o extable.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
@@ -23,7 +23,7 @@ lib-y	+= kobject.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 gcd.o lcm.o list_sort.o uuid.o flex_array.o clz_ctz.o\
+	 gcd.o lcm.o list_sort.o uuid.o flex_array.o clz_ctz.o iovec.o \
 	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
