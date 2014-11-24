Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaKXCuP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:50:15 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42622 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaKXCuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:50:13 -0500
Message-ID: <54729CDE.5030700@hitachi.com>
Date: Mon, 24 Nov 2014 11:50:06 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH ftrace/core v6 5/5] kselftest, ftrace: Add ftrace IPMODIFY
 flag test
References: <20141121102502.11844.82696.stgit@localhost.localdomain> <20141121102537.11844.9781.stgit@localhost.localdomain> <20141121160329.575fd043@gandalf.local.home>
In-Reply-To: <20141121160329.575fd043@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/22 6:03), Steven Rostedt wrote:
> On Fri, 21 Nov 2014 05:25:37 -0500
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Add ftrace IPMODIFY flag test to selftest/ftrace. The
>> test checks simple ftrace handler insertion and
>> combinations of ftrace, kprobe, and jprobe.
>> This test requires kernel build tree to build a test
>> kernel module and root privilege to run.
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>
>> ---
> 
> Can you make it so that make O=/path/to/build works?

Hmm, I always use "O=builddir" option in my build script...

> 
> I tried running this on my test box, which has /home/rostedt mounted
> read only from my build box, and I get this:

My case is just to keep the source tree clean, so source tree is
still writable and builddir is under another directory in /home/<user>/.


> [root@bxtest ftrace]# make O=/tmp
> for TARGET in ipmodify; do \
> 	make -C $TARGET; \
> done;
> make[1]: Entering directory `/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify'
> make -C /lib/modules/3.18.0-rc1-test+/build M=/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify ipmodify.ko
> make[2]: Entering directory `/home/rostedt/work/git/nobackup/bxtest/trace'
>   CC [M]  /work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify/ipmodify.o
> /bin/sh: ./scripts/recordmcount: Permission denied

Hmm, this error looks odd, not ENOENT but EPERM??
Could you run it again with V=1 ?

Thank you,

> make[5]: *** [/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify/ipmodify.o] Error 1
> make[4]: *** [ipmodify.ko] Error 2
> make[3]: *** [sub-make] Error 2
> make[2]: *** [__sub-make] Error 2
> make[2]: Leaving directory `/home/rostedt/work/git/nobackup/bxtest/trace'
> make[1]: *** [ipmodify.ko] Error 2
> make[1]: Leaving directory `/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify'
> make: *** [all] Error 2
> 
> -- Steve
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


