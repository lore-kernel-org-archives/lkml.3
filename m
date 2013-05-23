Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab3EWHqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 03:46:35 -0400
Received: from ozlabs.org ([203.10.76.45]:51474 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173Ab3EWHqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 03:46:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <rdunlap@infradead.org>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH mainline] lib: make iovec obj instead of lib
In-Reply-To: <519DAD21.2050608@infradead.org>
References: <20130522234213.254ED31C6DC@corp2gmr1-1.hot.corp.google.com> <519DAD21.2050608@infradead.org>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 23 May 2013 16:44:35 +0930
Message-ID: <87r4gyqias.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> writes:
> when CONFIG_VMWARE_VMCI=m:
>
> ERROR: "memcpy_toiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!
> ERROR: "memcpy_fromiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!
>
> Changing iovec.o from lib-y to obj-y fixes the build errors.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.

> ---
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Fix build error io vmw_vmci.ko by chaning iovec.o from lib-y to
> obj-y.
>
> ERROR: "memcpy_toiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!
> ERROR: "memcpy_fromiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
>  lib/Makefile |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- mmotm-2013-0522-1640.orig/lib/Makefile
> +++ mmotm-2013-0522-1640/lib/Makefile
> @@ -9,7 +9,7 @@ endif
>  
>  lib-y := ctype.o string.o vsprintf.o cmdline.o \
>  	 rbtree.o radix-tree.o dump_stack.o timerqueue.o\
> -	 idr.o int_sqrt.o extable.o iovec.o \
> +	 idr.o int_sqrt.o extable.o \
>  	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
>  	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
>  	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
> @@ -23,7 +23,7 @@ lib-y	+= kobject.o klist.o
>  
>  obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
>  	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
> -	 gcd.o lcm.o list_sort.o uuid.o flex_array.o clz_ctz.o\
> +	 gcd.o lcm.o list_sort.o uuid.o flex_array.o clz_ctz.o iovec.o \
>  	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o
>  obj-y += string_helpers.o
>  obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
