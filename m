Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaKXEaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 23:30:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:11309 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751300AbaKXEaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 23:30:08 -0500
Date: Sun, 23 Nov 2014 23:29:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH ftrace/core v6 5/5] kselftest, ftrace: Add ftrace
 IPMODIFY flag test
Message-ID: <20141123232932.1ed70d18@gandalf.local.home>
In-Reply-To: <54729CDE.5030700@hitachi.com>
References: <20141121102502.11844.82696.stgit@localhost.localdomain>
	<20141121102537.11844.9781.stgit@localhost.localdomain>
	<20141121160329.575fd043@gandalf.local.home>
	<54729CDE.5030700@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014 11:50:06 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2014/11/22 6:03), Steven Rostedt wrote:
> > On Fri, 21 Nov 2014 05:25:37 -0500
> > Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> > 
> >> Add ftrace IPMODIFY flag test to selftest/ftrace. The
> >> test checks simple ftrace handler insertion and
> >> combinations of ftrace, kprobe, and jprobe.
> >> This test requires kernel build tree to build a test
> >> kernel module and root privilege to run.
> >>
> >> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> >>
> >> ---
> > 
> > Can you make it so that make O=/path/to/build works?
> 
> Hmm, I always use "O=builddir" option in my build script...

But do you use O=builddir where builddir is where the kernel was built?
I don't.

Remember, I build on a server and install on a test box. The server
directory is read only. I can not have O= be the path to where the
kernel was built. I have to use a different directory.


> 
> > 
> > I tried running this on my test box, which has /home/rostedt mounted
> > read only from my build box, and I get this:
> 
> My case is just to keep the source tree clean, so source tree is
> still writable and builddir is under another directory in /home/<user>/.
> 
> 
> > [root@bxtest ftrace]# make O=/tmp
> > for TARGET in ipmodify; do \
> > 	make -C $TARGET; \
> > done;
> > make[1]: Entering directory `/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify'
> > make -C /lib/modules/3.18.0-rc1-test+/build M=/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify ipmodify.ko
> > make[2]: Entering directory `/home/rostedt/work/git/nobackup/bxtest/trace'
> >   CC [M]  /work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify/ipmodify.o
> > /bin/sh: ./scripts/recordmcount: Permission denied
> 
> Hmm, this error looks odd, not ENOENT but EPERM??
> Could you run it again with V=1 ?

Sure, here's the output:

[root@bxtest ftrace]# make V=1 O=/tmp
for TARGET in ipmodify; do \
	make -C $TARGET; \
done;
make[1]: Entering directory `/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify'
make -C /lib/modules/3.18.0-rc1-test+/build M=/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify ipmodify.ko
make[2]: Entering directory `/home/rostedt/work/git/nobackup/bxtest/trace'
make -C /home/rostedt/work/git/linux-trace.git O=/home/rostedt/work/git/nobackup/bxtest/trace/. ipmodify.ko
make -C /home/rostedt/work/git/nobackup/bxtest/trace KBUILD_SRC=/home/rostedt/work/git/linux-trace.git \
-f /home/rostedt/work/git/linux-trace.git/Makefile ipmodify.ko
test -e include/generated/autoconf.h -a -e include/config/auto.conf || (		\
echo >&2;							\
echo >&2 "  ERROR: Kernel configuration is invalid.";		\
echo >&2 "         include/generated/autoconf.h or include/config/auto.conf are missing.";\
echo >&2 "         Run 'make oldconfig && make prepare' on kernel src to fix it.";	\
echo >&2 ;							\
/bin/false)
mkdir -p /work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify/.tmp_versions ; rm -f /work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify/.tmp_versions/*
make KBUILD_MODULES=1   \
-f /home/rostedt/work/git/linux-trace.git/scripts/Makefile.build obj=/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify ipmodify.o
  gcc -Wp,-MD,/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify/.ipmodify.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.7.2/include -I/home/rostedt/work/git/linux-trace.git/arch/x86/include -Iarch/x86/include/generated  -I/home/rostedt/work/git/linux-trace.git/include -Iinclude -I/home/rostedt/work/git/linux-trace.git/arch/x86/include/uapi -Iarch/x86/include/generated/uapi -I/home/rostedt/work/git/linux-trace.git/include/uapi -Iinclude/generated/uapi -include /home/rostedt/work/git/linux-trace.git/include/linux/kconfig.h   -I/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -m64 -mno-80387 -mno-fp-ret-in-387 -mtune=generic -mno-red-zone -mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1 -DCONFIG_AS_FXSAVEQ=1 -DCONFIG_AS_CRC32=1 -DCONFIG_AS_AVX=1 -DCONFIG_AS_AVX2=1 -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -fno-delete-null-pointer-checks -Os -Wno-maybe-uninitialized --param=allow-store-data-races=0 -Wframe-larger-than=2048 -fno-stack-protector -Wno-unused-but-set-variable -fno-omit-frame-pointer -fno-optimize-sibling-calls -fno-var-tracking-assignments -g -pg -mfentry -DCC_USING_FENTRY -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -Werror=implicit-int -Werror=strict-prototypes -DCC_HAVE_ASM_GOTO  -DMODULE  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(ipmodify)"  -D"KBUILD_MODNAME=KBUILD_STR(ipmodify)" -c -o /work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify/ipmodify.o /work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify/ipmodify.c
  if [ "-pg" = "-pg" ]; then if [ /work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify/ipmodify.o != "scripts/mod/empty.o" ]; then ./scripts/recordmcount  "/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify/ipmodify.o"; fi; fi;
/bin/sh: ./scripts/recordmcount: Permission denied
make[5]: *** [/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify/ipmodify.o] Error 1
make[4]: *** [ipmodify.ko] Error 2
make[3]: *** [sub-make] Error 2
make[2]: *** [__sub-make] Error 2
make[2]: Leaving directory `/home/rostedt/work/git/nobackup/bxtest/trace'
make[1]: *** [ipmodify.ko] Error 2
make[1]: Leaving directory `/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify'
make: *** [all] Error 2


Thanks (on my way to bed),

-- Steve
