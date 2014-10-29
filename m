Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbaJ2TeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:34:22 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:42196 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbaJ2TeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:34:20 -0400
MIME-Version: 1.0
In-Reply-To: <20141028222929.GA29476@linux.vnet.ibm.com>
References: <20141028222929.GA29476@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 29 Oct 2014 15:33:48 -0400
Message-ID: <CAJhHMCCpHRbue9JD0i9UPfAjYONVccYaEHJDSb6uHW8DAiNF8g@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 0/6] Torture-test changes for 3.19
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

On Tue, Oct 28, 2014 at 6:29 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> Hello!
>
> This series provides torture-testing updates:
>
> 1.      Run the Linux-kernel binary out of the results directory,
>         easing re-runs.
>
> 2.      Add early-boot callback-posting self-tests for RCU, courtesy
>         of Pranith Kumar.
>
> 3.      Enable early-boot callback-posting self-tests in rcutorture,
>         courtesy of Pranith Kumar.
>
> 4.      Remove old-version rcutorture configuration files, courtesy
>         of Pranith Kumar.
>
> 5.      Remove the --kversion parameter to kvm.sh, courtesy of Pranith
>         Kumar.
>
> 6.      Fix rcu_torture_cbflood() memory leak.


For 1 and 6:

Reviewed-by: Pranith Kumar <bobby.prani@gmail.com>

>
>                                                         Thanx, Paul
>
> ------------------------------------------------------------------------
>
>  a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST                    |   14 -
>  a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP       |   18 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp       |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp       |   22 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP       |   18 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp       |   22 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh                    |   23 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH                    |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP       |   19 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp       |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp       |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP       |   22 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp       |   27 ---
>  a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh                    |   23 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH                    |   22 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh          |   33 ---
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST                   |   17 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP      |   19 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp      |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp      |   22 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP      |   18 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp      |   22 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp      |   19 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP      |   26 ---
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP      |   22 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh                   |   23 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH                   |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP      |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp      |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp      |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP      |   22 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp      |   27 ---
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp      |   18 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP      |   30 ---
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all  |   30 ---
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none |   30 ---
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp      |   30 ---
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh                   |   23 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH                   |   22 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST                    |   14 -
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP       |   19 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp       |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp       |   22 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP       |   18 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp       |   22 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh                    |   23 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH                    |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP       |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp       |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp       |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP       |   22 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp       |   27 ---
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh                    |   23 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH                    |   22 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh          |   44 -----
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST                    |   14 -
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP       |   19 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp       |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp       |   22 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP       |   18 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp       |   22 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh                    |   23 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH                    |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP       |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp       |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp       |   20 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP       |   22 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp       |   27 ---
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh                    |   23 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH                    |   22 --
>  a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh          |   57 ------
>  b/kernel/rcu/rcu.h                                                              |    2
>  b/kernel/rcu/rcutorture.c                                                       |    1
>  b/kernel/rcu/tiny.c                                                             |    4
>  b/kernel/rcu/tree.c                                                             |    2
>  b/kernel/rcu/update.c                                                           |   84 ++++++++++
>  b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh                      |    6
>  b/tools/testing/selftests/rcutorture/bin/kvm.sh                                 |   19 --
>  b/tools/testing/selftests/rcutorture/configs/rcu/TINY02                         |    2
>  b/tools/testing/selftests/rcutorture/configs/rcu/TINY02.boot                    |    2
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot                    |    1
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE06.boot                    |    3
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE08                         |    2
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot                    |    2
>  84 files changed, 112 insertions(+), 1606 deletions(-)
>



-- 
Pranith
