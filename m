Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab3EVEP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 00:15:59 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:32773 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3EVEP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 00:15:58 -0400
MIME-Version: 1.0
In-Reply-To: <519AF05E.1050808@huawei.com>
References: <519AF05E.1050808@huawei.com>
Date: Wed, 22 May 2013 12:15:57 +0800
Message-ID: <CACVXFVMG73_OCJOJGWR0CCeoR3taXnj+PXXah0q7fyB=Y4vfwQ@mail.gmail.com>
Subject: Re: [ANNOUNCE] ktap 0.1 released
From: Ming Lei <tom.leiming@gmail.com>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 11:56 AM, zhangwei(Jovi)
<jovi.zhangwei@huawei.com> wrote:
>
> Dear,
>
> I'm pleased to announce that ktap release v0.1, this is the first official
> release of ktap project, it is expected that this release is not fully
> functional or very stable and we welcome bug reports and fixes for the issues.
>
> = what's ktap?
>
>    A New Scripting Dynamic Tracing Tool For Linux
>
>    KTAP is a new scripting dynamic tracing tool for Linux, it uses a
>    scripting language and lets users trace the Linux kernel dynamically.
>    KTAP is designed to give operational insights with interoperability
>    that allow users to tune, troubleshoot and extend kernel and application.
>
>    KTAP have different design principles from Linux mainstream dynamic tracing
>    language in that it's based on bytecode, so it doesn't depend upon GCC,
>    doesn't require compiling a kernel module, safe to use in production
>    environment, fulfilling the embedd ecosystem's tracing needs.
>
>    KTAP also is designed for enabling great interoperability with Linux kernel,
>    it gives user the power to modify and extend the system, and let users
>    explore the system in an easy way.
>
>    KTAP is released as GPL license.
>
>    More information can be found at ktap/doc directory.
>
> = Features
>
>    Because this is the first release, so there wouldn't include too much features,
>    just contain several basic features about tracing,  here are the summary:
>
>    1) support x86-32 and x86-64 (other arch is not tested yet)
>    2) support tracepoints, syscalls, kprobes, kretprobes
>    3) timer
>    4) dumpstack
>    5) many built-in functions and library functions in there
>
>    There have many features on the todo list, so it will support more
>    features in future, and be more stable than this release.
>
> = Planned Changes
>
>    we are planning to enable more kernel ineroperability into ktap, implement more
>    sample scripts, and performance boost.
>
> = Code
>
>    Please download code from:
>    https://github.com/ktap/ktap.git
>
> = Building & Running
>
>    [root@jovi]# cd linux/kernel/trace/
>    [root@jovi]# git clone https://github.com/ktap/ktap.git
>
>    [root@jovi]# cd linux/kernel/trace/ktap
>    [root@jovi]# make       #generate ktapvm kernel module
>    [root@jovi]# make ktap  #generate userspace ktap tool
>
>    [root@jovi]# insmod ./ktapvm.ko
>    [root@jovi]# ./ktap scripts/syscalls.kp
>
>
> = Simple syscall tracing example
>
>         function eventfun (e) {
>                 printf("%d %d\t%s\t%s", cpu(), pid(), execname(), e.tostring())
>         }
>
>         kdebug.probe("tp:syscalls", eventfun)
>
>         kdebug.probe_end(function () {
>                 printf("probe end\n")
>         })
>
>
> = Examples/Documentation
>
>    Example is in ktap/scripts/
>    Documentation is in ktap/doc/

Nice job, I have run it on ARM already with only one line change.

But looks 'Control-C' can't stop the tracing or need some time to complete it,
see below:

$sudo ./ktap scripts/syscalls_histogram.kp
.....
Press Control-C to stop.
^C
^C^C^C
^C
                          value ------------- Distribution ------------- count
        sys_enter_rt_sigprocmask |@@@@@@@@@@@@@
  70
                sys_enter_select |@@@@@@@@@
  49
                  sys_enter_read |@@@@
  25
                 sys_enter_write |@@@@
  22
         sys_enter_clock_gettime |@@@
  19
                 sys_enter_ioctl |@
  6
          sys_enter_gettimeofday |
  4
                sys_enter_munmap |
  3
               sys_enter_fstat64 |
  3
                  sys_enter_open |
  3
                 sys_enter_close |
  3
          sys_enter_rt_sigaction |
  1
             sys_enter_nanosleep |
  1
                sys_enter_stat64 |
  1



Thanks,
-- 
Ming Lei
