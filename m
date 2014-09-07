Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaIGRJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 13:09:36 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:34543 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbaIGRJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 13:09:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140828191203.GA26955@linux.vnet.ibm.com>
References: <20140828191203.GA26955@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Sun, 7 Sep 2014 13:09:02 -0400
Message-ID: <CAJhHMCBcwOyyTjebOp23WtA2PMfWWGDrwZqU9qCttgXSU-hJQQ@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 0/11] Torture-test changes for 3.18
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 3:12 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> Hello!
>
> This series contains torture-test updates:
>
> 1.      Fix sparse warning by making boost_mutex static, courtesy of
>         Pranith Kumar.
>
> 2.      Use bash shell for all torture test scripts, courtesy of Pranith
>         Kumar.
>
> 3.      Set executable flags on scripts and invoke by name, courtesy
>         of Pranith Kumar.
>
> 4.      Add "cd" step to initrd documentation.
>
> 5.      Test partial nohz_full= configuration to increased test coverage.
>
> 6.      Specify MAXSMP=y for TREE01 to increase test coverage.
>
> 7.      Specify CONFIG_CPUMASK_OFFSTACK=y for TREE07 to increase test
>         coverage.
>
> 8.      Use pr_alert/pr_cont when printing to avoid large buffers,
>         courtesy of Joe Perches.
>
> 9.      Add a callback-flood test to increase test coverage.
>
> 10.     Print PID in hung-kernel diagnostic message.
>
> 11.     Check for nul bytes in console output.
>
>                                                         Thanx, Paul


Reviewed-by: Pranith Kumar <bobby.prani@gmail.com>

>
> ------------------------------------------------------------------------
>
>  b/Documentation/kernel-parameters.txt                        |   18
>  b/include/linux/torture.h                                    |    2
>  b/kernel/rcu/rcutorture.c                                    |  215 +++++++----
>  b/kernel/torture.c                                           |   16
>  b/tools/testing/selftests/rcutorture/bin/config2frag.sh      |    6
>  b/tools/testing/selftests/rcutorture/bin/configcheck.sh      |    6
>  b/tools/testing/selftests/rcutorture/bin/configinit.sh       |    6
>  b/tools/testing/selftests/rcutorture/bin/functions.sh        |   20 +
>  b/tools/testing/selftests/rcutorture/bin/kvm-build.sh        |    4
>  b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh |    4
>  b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh  |    4
>  b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh      |    4
>  b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh   |    7
>  b/tools/testing/selftests/rcutorture/bin/kvm.sh              |    8
>  b/tools/testing/selftests/rcutorture/bin/parse-build.sh      |    7
>  b/tools/testing/selftests/rcutorture/bin/parse-console.sh    |   11
>  b/tools/testing/selftests/rcutorture/bin/parse-torture.sh    |    7
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE01      |    4
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE01.boot |    2
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE07      |    3
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE07.boot |    1
>  b/tools/testing/selftests/rcutorture/doc/initrd.txt          |    1
>  22 files changed, 233 insertions(+), 123 deletions(-)
>



-- 
Pranith
