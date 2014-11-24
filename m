Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbaKXPHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:07:41 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:48992 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753613AbaKXPHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:07:39 -0500
Date: Mon, 24 Nov 2014 10:07:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH ftrace/core v6 5/5] kselftest, ftrace: Add ftrace
 IPMODIFY flag test
Message-ID: <20141124100727.19531a3b@gandalf.local.home>
In-Reply-To: <54733C80.6060509@hitachi.com>
References: <20141121102502.11844.82696.stgit@localhost.localdomain>
	<20141121102537.11844.9781.stgit@localhost.localdomain>
	<20141121160329.575fd043@gandalf.local.home>
	<54729CDE.5030700@hitachi.com>
	<20141123232932.1ed70d18@gandalf.local.home>
	<54733C80.6060509@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014 23:11:12 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
 
> So, if your server directory is mounted with noexec, it's an environmental
> problem. I guess you can not build any kernel drivers on that testbox, can you?
> 

You're right about the noexec, even though my fstab has "exec" in it ??

I use a custom distcc build to build the kernel, and I don't waste time
setting up that environment for a testbox, which means I can't build a
module for the test kernels because it would be using a different
compiler in that case.


> Anyway, this gives us a good question, "should test binaries be made by
> server or client(testbox) environment?" This ipmodify driver is a binary
> and it should be built with the kernel binary (by server) I think.
> But yes, I missed the Makefile didn't allow that (this always referred
> installed running kernel builddir).
> 
> I hope to have CONFIG_KSELFTEST_BINARIES for Kconfig, or make prep_kselftest
> target to build these binaries with kernel...

Is that what this would need? I would think we could add a
CONFIG_KSELFTEST_MODULES, that would build any modules needed for
selftests and have them in /lib/modules just like any other module.

-- Steve

> 
> Shuah, what would you think about this?
> 
> > make[4]: *** [ipmodify.ko] Error 2
> > make[3]: *** [sub-make] Error 2
> > make[2]: *** [__sub-make] Error 2
> > make[2]: Leaving directory `/home/rostedt/work/git/nobackup/bxtest/trace'
> > make[1]: *** [ipmodify.ko] Error 2
> > make[1]: Leaving directory `/work/git/linux-trace.git/tools/testing/selftests/ftrace/ipmodify'
> > make: *** [all] Error 2
> > 
> > 
> > Thanks (on my way to bed),
> 
> Thank you :),
> 
> 

