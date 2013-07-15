Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3GOTlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:41:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44169 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928Ab3GOTlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:41:13 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <8992619.mp1cFCuObR@al>
References: <8992619.mp1cFCuObR@al>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: OOT build fails on x86_64 due to missing asm/unisd_64.h
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 15 Jul 2013 12:40:59 -0700
To: Peter Wu <lekensteyn@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <ddf0f5a9-a6f1-418f-8b41-41086986c694@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a clean directory?

Peter Wu <lekensteyn@gmail.com> wrote:

>Hi,
>
>When I tried to build v3.11-rc1-8-g47188d3 out-of-tree, I get an error
>about a
>missing asm/unistd_64.h file. The full build output (`git clean -xfd`
>was ran
>before baking the kernel):
>
>/home/me/Linux-src/build$ make O=$PWD -C ../linux -j8
>make: Entering directory `/home/me/Linux-src/linux'
>/home/me/Linux-src/linux/arch/x86/Makefile:107: CONFIG_X86_X32 enabled
>but no binutils support
>make[2]: Nothing to be done for `all'.
>  GEN     /tmp/build/Makefile
>  CHK     include/generated/uapi/linux/version.h
>make[2]: Nothing to be done for `relocs'.
>  Using /home/me/Linux-src/linux as source for kernel
>  CHK     include/generated/utsrelease.h
>  UPD     include/generated/utsrelease.h
>  CC      kernel/bounds.s
>  GEN     include/generated/bounds.h
>  CC      arch/x86/kernel/asm-offsets.s
>In file included from
>/home/me/Linux-src/linux/include/uapi/linux/unistd.h:7:0,
>     from /home/me/Linux-src/linux/arch/x86/include/asm/seccomp_64.h:4,
>        from /home/me/Linux-src/linux/arch/x86/include/asm/seccomp.h:4,
>               from /home/me/Linux-src/linux/include/linux/seccomp.h:9,
>                from /home/me/Linux-src/linux/include/linux/sched.h:39,
>         from /home/me/Linux-src/linux/arch/x86/kernel/asm-offsets.c:9:
>/home/me/Linux-src/linux/arch/x86/include/asm/unistd.h:23:29: fatal
>error: asm/unistd_64.h: No such file or directory
>compilation terminated.
>make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1
>make[1]: *** [prepare0] Error 2
>make: *** [sub-make] Error 2
>make: Leaving directory `/home/me/Linux-src/linux'
>
>
>
>As a workaround, I rsync the files that are placed in the source tree:
>
>~/Linux-src/linux/arch/x86/include/generated$ rsync -av .
>/tmp/build/arch/x86/include/generated/
>sending incremental file list
>./
>asm/
>asm/syscalls_32.h
>uapi/
>uapi/asm/
>uapi/asm/unistd_32.h
>uapi/asm/unistd_64.h                                                   
>                                                                       
>uapi/asm/unistd_x32.h
>
>
>I have encountered this error some releases back, and some others
>reported
>this before[1]. If you need more details (.config?), please ask.
>
>Regards,
>Peter
>
>
> [1]: http://lkml.org/lkml/2012/3/19/680

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
