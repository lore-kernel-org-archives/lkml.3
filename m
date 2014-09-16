Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaIPWVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:21:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:56635 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752975AbaIPWVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:21:13 -0400
Date: Tue, 16 Sep 2014 18:21:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v3 1/4] ftracetest: Initial commit for ftracetest
Message-ID: <20140916182109.4fff4169@gandalf.local.home>
In-Reply-To: <20140902110639.3207.38388.stgit@kbuild-f20.novalocal>
References: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal>
	<20140902110639.3207.38388.stgit@kbuild-f20.novalocal>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> diff --git a/tools/testing/ftrace/README b/tools/testing/ftrace/README
> new file mode 100644
> index 0000000..5d5de16
> --- /dev/null
> +++ b/tools/testing/ftrace/README
> @@ -0,0 +1,45 @@
> +Linux Ftrace Testcases
> +
> +This is a collection of testcases for ftrace tracing feature in the Linux
> +kernel. Since ftrace exports interfaces via the debugfs, we just need
> +shell scripts for testing. Feel free to add new test cases.
> +
> +Running the ftrace testcases
> +============================
> +
> +At first, you need to be the root user to run this script.
> +To run all testcases:
> +
> +  $ sudo ./ftracetest
> +
> +To run specific testcases:
> +
> +  # ./ftracetest test.d/basic3.tc
> +
> +Or you can also run testcases under given directory:
> +
> +  # ./ftracetest test.d/kprobe/
> +
> +Contributing new testcases
> +==========================
> +
> +Copy test.d/template to your testcase (whose filename must has *.tc extension)

"whose filename must have *.tc extension"

> +and rewrite test description line.

"and rewrite the test description line"

> +
> + * The working directory of the script is <debugfs>/tracing/.
> +
> + * Take care about the side effect, because that is run with root privilege.

 "Take care with side effects as the tests are run with root privilege"

> +
> + * Don't take too long. It's a kind of unit test.

 "The tests should not run for a long period of time. These are to be
 unit tests"

We should probably specify what the time should be. Is 20 minutes too
long?


> +
> + * You can add a directory for your testcases under test.d/ if needed.
> +
> + * The test cases should run on dash (busybox shell) for testing on
> +   minimal cross-build environments.
> +
> +TODO
> +====
> +
> + * Fancy colored output :)
> +
> + * Integrate with selftest?
> diff --git a/tools/testing/ftrace/ftracetest b/tools/testing/ftrace/ftracetest
> new file mode 100755
> index 0000000..8d92e74
> --- /dev/null
> +++ b/tools/testing/ftrace/ftracetest
> @@ -0,0 +1,152 @@
> +#!/bin/sh
> +# ftracetest - Ftrace test shell scripts
> +# Written by Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Maybe add your copyright here, with year?

Also, we should probably state that this is under the GPL v2?

-- Steve

> +
> +usage() { # errno [message]
> +[ "$2" ] && echo $2
> +echo "Usage: ftracetest [options] [testcase(s)] [testcase-directory(s)]"
> +echo " Options:"
> +echo "		-h|--help  Show help message"
> +echo "		-k|--keep  Keep passed test logs"
> +echo "		-d|--debug Debug mode (trace all shell commands)"
> +exit $1
> +}
