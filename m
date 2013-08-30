Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab3H3P7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:59:11 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:55436 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285Ab3H3P7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:59:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ_BOiBubn61odZ51eqDw+-eaAhs5ZnuPESnudcaP8KZr2h8YA@mail.gmail.com>
References: <CAJ_BOiB6E4D-Y45VZTOGqhYMs_FG8UTpGnNdzjdj3nEP13A=3g@mail.gmail.com>
	<CAJ_BOiBubn61odZ51eqDw+-eaAhs5ZnuPESnudcaP8KZr2h8YA@mail.gmail.com>
Date: Fri, 30 Aug 2013 21:29:09 +0530
Message-ID: <CAJ_BOiCV50yzx4WhW=wVzNmq3PoZRP0e7Qqb5byGiG53tr0JVg@mail.gmail.com>
Subject: Re: wakeup tracer not able to capture traces on 3.4 kernel
From: Prabhat Kumar Ravi <prabhatravi09@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to all, I got solution, this issue is due to lack of proper
timer implementation.

On Thu, Aug 29, 2013 at 8:42 PM, Prabhat Kumar Ravi
<prabhatravi09@gmail.com> wrote:
> On Thu, Aug 29, 2013 at 7:41 PM, Prabhat Kumar Ravi
> <prabhatravi09@gmail.com> wrote:
>> Hi,
>>
>> I trying to capture traces through wakeup tracer, but not able to
>> capture it on 3.4 kernel with cortex A9 processor, armv7.
>> {{{
>> / # mount -t debugfs nodev /debug
>> / # sysctl kernel.ftrace_enabled=1
>> kernel.ftrace_enabled = 1
>> / # echo wakeup > /debug/tracing/current_tracer
>> / # echo latency-format > /debug/tracing/trace_options
>> / # echo 0 > /debug/tracing/tracing_max_latency
>> / # echo 1 > /debug/tracing/tracing_on
>> / # sleep 10
>> / # echo 0 > /debug/tracing/tracing_on
>> / # cat /debug/tracing/trace
>> # tracer: wakeup
>> #
>> }}}
>
> My target board is xilinx-zc702,
> here in kernel/trace/trace.c:
> void tracing_record_cmdline(struct task_struct *tsk)
> {
> if (atomic_read(&trace_record_cmdline_disabled) || !tracer_enabled ||
>    !tracing_is_on())
> -------------------------------> it not coming here at all.
> return;
>
> trace_save_cmdline(tsk);
> }

 Regards,
 Prabhat
