Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaBJR33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:29:29 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:59206 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaBJR3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:29:25 -0500
MIME-Version: 1.0
In-Reply-To: <20140207093452.0ecab55f@gandalf.local.home>
References: <CAAH=MDxg22r78x0szzr_gjqxgfL5ZCGehRxSqAmNcfxiP390QA@mail.gmail.com>
	<20140207093452.0ecab55f@gandalf.local.home>
Date: Mon, 10 Feb 2014 22:59:24 +0530
Message-ID: <CAAH=MDydEbG-iDC92G18U4iDtD6vMcegGSuzK4Kihq+vz7eQQA@mail.gmail.com>
Subject: Re: [Ftrace][Bug] Failed on adding breakpoints, when used with kgdboc
From: yogesh tillu <tillu.yogesh@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Prasun Kapoor <Prasun.Kapoor@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,
     Thanks for the reply.
Can we follow the approach of using api ftrace_set_notrace_ip (like
ftrace_set_filter_ip ), and register ip for the notrace hash list from
kgdb x86 arch code at the time of adding/removing breakpoint.


On Fri, Feb 7, 2014 at 8:04 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 7 Feb 2014 19:38:35 +0530
> yogesh tillu <tillu.yogesh@gmail.com> wrote:
>
>> Issue: [On x86 64 bit setup] If we enable CONFIG_FTRACE_STARTUP_TEST,
>> and set software breakpoint(from kgdboc) result into below mentioned
>> oops and non working of kgdb software breakpoint.
>
> Patient: Doctor, it hurts me when I do this.
>
> Doctor: Then don't do that.
>
>>
>> [  347.686031] ------------[ cut here ]------------
>> [  348.728729] WARNING: at kernel/trace/ftrace.c:1688 ftrace_bug+0x209/0x250()
>> [  348.787984] Modules linked in:
>> [  348.894035] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W
>> 3.10.26.x86-generic-64-rt22 #17
>> [  348.955562] Hardware name: Intel Corporation
>> BIOS S1200BT.86B.02.00.0035.030220120927 03/02/2012
>> [  349.021339]  ffff88013acbbd10 ffff88013acbbd18 ffffffff8180b2b4
>> ffff88013acbbd58
>> [  349.021353]  ffffffff81041fc0 ffffffff819e376d ffffffff81816360
>> ffffffff819cc2ee
>> [  349.021367]  0000000000007240 ffffffff81db3880 ffffffff8181a050
>> ffff88013acbbd68
>> [  349.200624] Call Trace:
>> [  349.254776]  [<ffffffff8180b2b4>] dump_stack+0x19/0x1b
>> [  349.254789]  [<ffffffff81041fc0>] warn_slowpath_common+0x70/0xa0
>> [  349.254800]  [<ffffffff81816360>] ? __do_page_fault+0x4e0/0x4e0
>> [  349.254816]  [<ffffffff8181a050>] ? __fentry__+0x10/0x10
>> [  349.254828]  [<ffffffff8104200a>] warn_slowpath_null+0x1a/0x20
>> [  349.254839]  [<ffffffff810e19e9>] ftrace_bug+0x209/0x250
>> [  349.254854]  [<ffffffff8102c99c>] ftrace_replace_code+0x2bc/0x460
>> [  349.254882]  [<ffffffff810e244a>] ftrace_modify_all_code+0x7a/0xb0
>> [  349.254896]  [<ffffffff8102cb50>] arch_ftrace_update_code+0x10/0x20
>> [  349.254908]  [<ffffffff810e24e2>] ftrace_run_update_code+0x22/0x80
>> [  349.254922]  [<ffffffff810e2579>] ftrace_startup_enable+0x39/0x50
>> [  349.254934]  [<ffffffff810e2ac0>] ftrace_startup+0xc0/0x260
>> [  349.254952]  [<ffffffff810e2c8d>] register_ftrace_function+0x2d/0x50
>> [  349.254964]  [<ffffffff81c1349f>] ? event_trace_self_tests+0x2e7/0x2e7
>> [  349.254976]  [<ffffffff81c134bd>] event_trace_self_tests_init+0x1e/0x69
>> [  349.254988]  [<ffffffff81000362>] do_one_initcall+0x102/0x130
>> [  349.255010]  [<ffffffff81bf6018>] kernel_init_freeable+0x18b/0x225
>> [  349.255021]  [<ffffffff81bf5866>] ? do_early_param+0x87/0x87
>> [  349.255032]  [<ffffffff817f76a0>] ? rest_init+0x90/0x90
>> [  349.255048]  [<ffffffff817f76ae>] kernel_init+0xe/0xf0
>> [  349.255060]  [<ffffffff8181a3d2>] ret_from_fork+0x72/0xa0
>> [  349.255078]  [<ffffffff817f76a0>] ? rest_init+0x90/0x90
>> [  349.255107] ---[ end trace 0000000000000002 ]---
>> [  350.585736] ftrace failed to modify [<ffffffff81816360>]
>> do_page_fault+0x0/0x10
>> [  350.696684]  actual: cc:1f:44:00:00
>> [  351.059427] Failed on adding breakpoints (29248):
>
> Ftrace is very paranoid about making sure everything goes correctly,
> because it is modifying kernel text. It checks that what it is
> modifying is what it expects to be there before it modifies it.
>
> The above states that it failed when modifying the __fentry__ location
> in do_page_fault. It also shows us what it found:
>
>   actual: cc:1f:44:00:00
>
> What it expected to find was:  0f:1f:44:00:00
>
> Noticed that a "cc" was in place of the "0f". I also know that on
> x86_64, that "cc" is the machine op code of a breakpoint.
>
> Something tells me that on boot up, kgdb will add a breakpoint to
> do_page_fault. If it does that on boot up, and you have the ftrace
> start up tests enabled, it will cause ftrace to fail.
>
>>
>>
>> Setup Details
>>
>> a) System details
>> X86 64 bit
>> kernel version: 3.10.26
>>
>> b) Configuration
>> FTRACE & KGDB is enabled
>> - using kgdb over console ( KGDBOC )
>>
>> c) Steps to reproduce
>> Boot kernel, it will wait for kgdboc to connect
>> start gdb, connect to target and set breakpoint with break command,
>> and continue.
>> Kernel will boot with above mentions oops, resulting gdb to wait
>> forever for breakpoint.
>>
>> d) Observation: If we disable CONFIG_FTRACE_STARTUP_TEST,
>> breakpoint(kgdboc) is working fine.
>
> That's exactly what I would expect.
>
>>
>> Could you please let me know if anyone came accross this issue ?
>>
>
> Nope, you are the first I heard of this, but it makes perfect sense.
> Perhaps the solution should be something like this (totally untested):
>
> diff --git a/drivers/tty/serial/kgdboc.c b/drivers/tty/serial/kgdboc.c
> index a260cde..eebf370 100644
> --- a/drivers/tty/serial/kgdboc.c
> +++ b/drivers/tty/serial/kgdboc.c
> @@ -20,6 +20,7 @@
>  #include <linux/vt_kern.h>
>  #include <linux/input.h>
>  #include <linux/module.h>
> +#include <linux/ftrace.h>
>
>  #define MAX_CONFIG_LEN         40
>
> @@ -139,6 +140,9 @@ static int kgdboc_option_setup(char *opt)
>         }
>         strcpy(config, opt);
>
> +       /* kgdb causes ftrace self tests to fail (false negatives) */
> +       disable_ftrace_selftest();
> +
>         return 0;
>  }
>
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index f4233b1..54ff26c 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -19,6 +19,12 @@
>
>  #include <asm/ftrace.h>
>
> +#if defined(CONFIG_FUNCTION_TRACER) && defined(CONFIG_FTRACE_STARTUP_TEST)
> +extern void disable_ftrace_selftest(void);
> +#else
> +static inline void disable_ftrace_selftest(void) { }
> +#endif
> +
>  /*
>   * If the arch supports passing the variable contents of
>   * function_trace_op as the third parameter back from the
> diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
> index a7329b7..063561a 100644
> --- a/kernel/trace/trace_selftest.c
> +++ b/kernel/trace/trace_selftest.c
> @@ -635,6 +635,13 @@ out:
>         return ret;
>  }
>
> +static bool ftrace_selftest_disabled;
> +
> +void disable_ftrace_selftest(void)
> +{
> +       ftrace_selftest_disabled = true;
> +}
> +
>  /*
>   * Simple verification test of ftrace function tracer.
>   * Enable ftrace, sleep 1/10 second, and then read the trace
> @@ -654,6 +661,11 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
>         }
>  #endif
>
> +       if (ftrace_selftest_disabled) {
> +               printk(KERN_CONT " ... DISABLED: force PASS ... ");
> +               return 0;
> +       }
> +
>         /* make sure msleep has been recorded */
>         msleep(1);
>
> @@ -748,6 +760,11 @@ trace_selftest_startup_function_graph(struct tracer *trace,
>         }
>  #endif
>
> +       if (ftrace_selftest_disabled) {
> +               printk(KERN_CONT " ... DISABLED: force PASS ... ");
> +               return 0;
> +       }
> +
>         /*
>          * Simulate the init() callback but we attach a watchdog callback
>          * to detect and recover from possible hangs
>
>
> -- Steve



-- 
Thanks,
Yogesh
