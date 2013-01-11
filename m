Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab3AKUnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:43:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32052 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab3AKUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:43:35 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=23BW25jA_k4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=e7Wcmqxzby8A:10 a=D19gQVrFAAAA:8 a=wmh7nHQ3qqaC0OkmsdwA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357937012.5141.39.camel@gandalf.local.home>
Subject: Re: [PATCH -tip  0/3] Move kprobes files under the kprobes directory
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Fri, 11 Jan 2013 15:43:32 -0500
In-Reply-To: <20120928081509.3560.8860.stgit@ltc138.sdl.hitachi.co.jp>
References: <20120928081509.3560.8860.stgit@ltc138.sdl.hitachi.co.jp>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 17:15 +0900, Masami Hiramatsu wrote:
> Hi,
> 
> Here are a series of patches to split ftrace-based kprobe part
> from arch/x86/kernel/kprobes.c and to move kprobes related
> files under arch/x86/kernel/kprobes/, according to Ingo's
> suggestion.
> https://lkml.org/lkml/2012/9/20/122
> 
> Thank you,

Hi Masami,

This seems to have slipped through the cracks. Is this patch series
still valid?

-- Steve

> 
> ---
> 
> Masami Hiramatsu (3):
>       ftrace: Move ARCH_SUPPORTS_FTRACE_SAVE_REGS in Kconfig
>       kprobes/x86: Move ftrace-based kprobe code into kprobes-ftrace.c
>       kprobes/x86: Move kprobes stuff under arch/x86/kernel/kprobes/
> 
> 
>  arch/Kconfig                     |   12 
>  arch/x86/Kconfig                 |    2 
>  arch/x86/include/asm/ftrace.h    |    1 
>  arch/x86/kernel/Makefile         |    3 
>  arch/x86/kernel/kprobes-common.h |  102 ---
>  arch/x86/kernel/kprobes-opt.c    |  512 -----------------
>  arch/x86/kernel/kprobes.c        | 1130 --------------------------------------
>  arch/x86/kernel/kprobes/Makefile |    7 
>  arch/x86/kernel/kprobes/common.h |  113 ++++
>  arch/x86/kernel/kprobes/core.c   | 1064 ++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/kprobes/ftrace.c |   93 +++
>  arch/x86/kernel/kprobes/opt.c    |  512 +++++++++++++++++
>  include/linux/ftrace.h           |    6 
>  include/linux/kprobes.h          |   12 
>  kernel/kprobes.c                 |    8 
>  kernel/trace/Kconfig             |    8 
>  kernel/trace/ftrace.c            |    6 
>  kernel/trace/trace_selftest.c    |    2 
>  18 files changed, 1824 insertions(+), 1769 deletions(-)
>  delete mode 100644 arch/x86/kernel/kprobes-common.h
>  delete mode 100644 arch/x86/kernel/kprobes-opt.c
>  delete mode 100644 arch/x86/kernel/kprobes.c
>  create mode 100644 arch/x86/kernel/kprobes/Makefile
>  create mode 100644 arch/x86/kernel/kprobes/common.h
>  create mode 100644 arch/x86/kernel/kprobes/core.c
>  create mode 100644 arch/x86/kernel/kprobes/ftrace.c
>  create mode 100644 arch/x86/kernel/kprobes/opt.c
> 


