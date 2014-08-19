Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaHSTiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 15:38:01 -0400
Received: from www17.your-server.de ([213.133.104.17]:54352 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaHSTiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 15:38:00 -0400
X-Greylist: delayed 1544 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Aug 2014 15:37:59 EDT
Message-ID: <1408475530.15309.7.camel@localhost.localdomain>
Subject: [UML] 3.16 build without optimization fails
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 19 Aug 2014 21:12:10 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> the build with -O0 fails with:
> 
> make -f scripts/Makefile.build obj=init
>   gcc -Wp,-MD,init/.main.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.8.3/include -I./arch/um/include -Iarch/um/include/generated  -Iinclude -I./arch/um/include/uapi -Iarch/um/include/generated/uapi -I./include/uapi -Iinclude/generated/uapi -include ./include/linux/kconfig.h -D__KERNEL__ -m64 -I./arch/x86/um -I./arch/x86/include -I./arch/x86/include/uapi -Iarch/x86/include/generated -Iarch/x86/include/generated/uapi -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -mcmodel=large -fno-builtin -m64 -funit-at-a-time -D__arch_um__ -I./arch/um/include/shared -I./arch/x86/um/shared -I./arch/um/include/shared/skas -Dvmap=kernel_vmap -Din6addr_loopback=kernel_in6addr_loopback -Din6addr_any=kernel_in6addr_any -Dstrrchr=kernel_strrchr -D_LARGEFILE64_SOURCE -Derrno=kernel_errno -Dsigprocmask=kernel_sigprocmask -Dmktime=kernel_mktime -fno-delete-null-pointer-checks -O0 -Wframe-larger-than=1024 -fno-stack-protector -Wno-unused-but-set-variable -fno-omit-frame-pointer -fno-optimize-sibling-calls -fno-var-tracking-assignments -g -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -Werror=implicit-int -Werror=strict-prototypes -DCC_HAVE_ASM_GOTO    -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(main)"  -D"KBUILD_MODNAME=KBUILD_STR(main)" -c -o init/main.o init/main.c
> In file included from ./arch/um/include/asm/fixmap.h:58:0,
>                  from ./arch/um/include/asm/pgtable.h:11,
>                  from include/linux/mm.h:51,
>                  from include/linux/ring_buffer.h:5,
>                  from include/linux/ftrace_event.h:5,
>                  from include/trace/syscall.h:6,
>                  from include/linux/syscalls.h:80,
>                  from init/main.c:18:
> include/asm-generic/fixmap.h: In function 'fix_to_virt':
> include/asm-generic/fixmap.h:31:2: error: size of unnamed array is negative
>   BUILD_BUG_ON(idx >= __end_of_fixed_addresses);
>   ^
> make[1]: *** [init/main.o] Error 1
> make: *** [init] Error 2
> 
> bug or feature?
> 
> any ideas?
> 
> switching BUILD_BUG_ON unconditionally to BUILD_BUG_ON_MSG - which uses compiletime_assert() - breaks the build a bit later here:
> 
>   gcc -Wp,-MD,arch/um/kernel/skas/.uaccess.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.8.3/include -I./arch/um/include -Iarch/um/include/generated  -Iinclude -I./arch/um/include/uapi -Iarch/um/include/generated/uapi -I./include/uapi -Iinclude/generated/uapi -include ./include/linux/kconfig.h -D__KERNEL__ -m64 -I./arch/x86/um -I./arch/x86/include -I./arch/x86/include/uapi -Iarch/x86/include/generated -Iarch/x86/include/generated/uapi -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -mcmodel=large -fno-builtin -m64 -funit-at-a-time -D__arch_um__ -I./arch/um/include/shared -I./arch/x86/um/shared -I./arch/um/include/shared/skas -Dvmap=kernel_vmap -Din6addr_loopback=kernel_in6addr_loopback -Din6addr_any=kernel_in6addr_any -Dstrrchr=kernel_strrchr -D_LARGEFILE64_SOURCE -Derrno=kernel_errno -Dsigprocmask=kernel_sigprocmask -Dmktime=kernel_mktime -fno-delete-null-pointer-checks -O0 -Wframe-larger-than=1024 -fno-stack-protector -Wno-unused-but-set-variable -fno-omit-frame-pointer -fno-optimize-sibling-calls -fno-var-tracking-assignments -g -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -Werror=implicit-int -Werror=strict-prototypes -DCC_HAVE_ASM_GOTO    -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(uaccess)"  -D"KBUILD_MODNAME=KBUILD_STR(uaccess)" -c -o arch/um/kernel/skas/uaccess.o arch/um/kernel/skas/uaccess.c
> In file included from include/linux/err.h:4:0,
>                  from arch/um/kernel/skas/uaccess.c:6:
> arch/um/kernel/skas/uaccess.c: In function 'do_op_one_page':
> include/linux/compiler.h:346:20: error: call to '__compiletime_assert_85' declared with attribute error: BUILD_BUG_ON failed: __same_type(((void *)addr), struct page *)
>     prefix ## suffix();    \
>                     ^
> include/linux/compiler.h:351:2: note: in expansion of macro '__compiletime_assert'
>   __compiletime_assert(condition, msg, prefix, suffix)
>   ^
> include/linux/compiler.h:363:2: note: in expansion of macro '_compiletime_assert'
>   _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
>   ^
> include/linux/bug.h:50:37: note: in expansion of macro 'compiletime_assert'
>  #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>                                      ^
> include/linux/bug.h:74:1: note: in expansion of macro 'BUILD_BUG_ON_MSG'
>  BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
>  ^
> include/linux/highmem.h:125:2: note: in expansion of macro 'BUILD_BUG_ON'
>   BUILD_BUG_ON(__same_type((addr), struct page *));       \
>   ^
> arch/um/kernel/skas/uaccess.c:85:2: note: in expansion of macro 'kunmap_atomic'
>   kunmap_atomic((void *)addr);
>   ^
> make[2]: *** [arch/um/kernel/skas/uaccess.o] Error 1
> make[1]: *** [arch/um/kernel/skas] Error 2
> make: *** [arch/um/kernel] Error 2
> 


