Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbaGNNqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:46:49 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5588 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbaGNNqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:46:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 14 Jul 2014 06:39:24 -0700
Message-ID: <53C3DF40.8050100@nvidia.com>
Date: Mon, 14 Jul 2014 16:46:40 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [for-next][PATCH 04/21] ftrace: Optimize function graph to be
 called directly
References: <20140703160503.006976702@goodmis.org>	<20140703161224.062459692@goodmis.org>	<53BED155.9040607@nvidia.com>	<20140711233610.551c274d@gandalf.local.home> <20140711233745.38d8e351@gandalf.local.home>
In-Reply-To: <20140711233745.38d8e351@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/07/14 06:37, Steven Rostedt wrote:
> On Fri, 11 Jul 2014 23:36:10 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> I'll worked on getting arm to be called directly too. Can you test that
>> patch as well? I'll reply to this email with that one.
>
> Here's that patch:
>
> -- Steve
>
>  From ff9ee792640d802415eaedf0e8d41992c898d2a9 Mon Sep 17 00:00:00 2001
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> Date: Fri, 11 Jul 2014 23:28:11 -0400
> Subject: [PATCH] ARM: ftrace: Allow function graph tracer to have its own
>   trampoline
>
> The ftrace infrastructure now allows the function graph tracer
> trampoline to be called directly instead of having to first go
> through the function tracer trampoline. But in order for this to
> work, the function graph tracer must be dependent from the function
> tracer trampoline. Currently in ARM, the function graph tracer
> does not save registers as it depends on the function tracer
> trampoline to do so.
>
> By adding a ftrace_graph_tramp_caller function that saves the regs
> then does the function graph tracing work, this can be used as
> the trampoline for function graph tracing.
>
> Link: http://lkml.kernel.org/r/53BED155.9040607@nvidia.com
>
> Reported-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>   arch/arm/include/asm/ftrace.h  | 5 +++++
>   arch/arm/kernel/entry-common.S | 7 +++++++
>   2 files changed, 12 insertions(+)
>
[...]

Thanks, both of these patches work for me.

Tested-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>

- Tuomas

-- 
nvpublic
