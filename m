Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaKUVDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:03:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:11390 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750838AbaKUVDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:03:42 -0500
Date: Fri, 21 Nov 2014 16:03:29 -0500
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
Message-ID: <20141121160329.575fd043@gandalf.local.home>
In-Reply-To: <20141121102537.11844.9781.stgit@localhost.localdomain>
References: <20141121102502.11844.82696.stgit@localhost.localdomain>
	<20141121102537.11844.9781.stgit@localhost.localdomain>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014 05:25:37 -0500
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Add ftrace IPMODIFY flag test to selftest/ftrace. The
> test checks simple ftrace handler insertion and
> combinations of ftrace, kprobe, and jprobe.
> This test requires kernel build tree to build a test
> kernel module and root privilege to run.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> ---

Can you make it so that make O=/path/to/build works?

I tried running this on my test box, which has /home/rostedt mounted
read only from my build box, and I get this:

[root@bxtest ftrace]# make O=/tmp
for TARGET in ipmodify; do \
	make -C $TARGET; \
done;
make[1]: Entering directory `/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify'
make -C /lib/modules/3.18.0-rc1-test+/build M=/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify ipmodify.ko
make[2]: Entering directory `/home/rostedt/work/git/nobackup/bxtest/trace'
  CC [M]  /work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify/ipmodify.o
/bin/sh: ./scripts/recordmcount: Permission denied
make[5]: *** [/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify/ipmodify.o] Error 1
make[4]: *** [ipmodify.ko] Error 2
make[3]: *** [sub-make] Error 2
make[2]: *** [__sub-make] Error 2
make[2]: Leaving directory `/home/rostedt/work/git/nobackup/bxtest/trace'
make[1]: *** [ipmodify.ko] Error 2
make[1]: Leaving directory `/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify'
make: *** [all] Error 2

-- Steve
