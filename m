Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3HWIda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:33:30 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10313 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3HWId2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:33:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 23 Aug 2013 01:31:08 -0700
Message-ID: <52171E4F.2020109@nvidia.com>
Date: Fri, 23 Aug 2013 16:33:19 +0800
From: Jiejing Zhang <jiejzhang@nvidia.com>
Reply-To: <jiejzhang@nvidia.com>
Organization: Nvidia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Jiejing Zhang <kzjeef@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Miao <emiao@nvidia.com>
Subject: Re: [PATCH] ftrace: add tgid information in task switch event.
References: <1377097520-24898-1-git-send-email-jasozhang@nvidia.com> <20130821110944.32bdf03a@gandalf.local.home> <20130821152305.GD31370@twins.programming.kicks-ass.net>
In-Reply-To: <20130821152305.GD31370@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/21/2013 11:23 PM, Peter Zijlstra wrote:
> On Wed, Aug 21, 2013 at 11:09:44AM -0400, Steven Rostedt wrote:
>>> From: Jiejing Zhang <jiejzhang@nvidia.com>
>>>
>>> ftrace only report pid in task switch event, which is
>>> actually thread ID in user space view, the comm of
>>> the thread will be like "Thread-1", "Compiler", etc
>>> in android system, it's useful if we can add tgid
>>> information in ftrace event to find out the process
>>> id, and the process id's comm will help us to figure
>>> out the application, which was useful on data analysis
>>> tools.
> Meh.. are you telling me you really can't do that otherwise?
>
> Adding this information makes the tracepoint slower for everybody else.
> How about you enable trace_sched_process_fork() and track things that
> way?
Thanks for the tip, I have tried fix this by avoid add tgid in ftrace,
actually the relationship between thread and process can be figure by 
analysis these two command's output:
`ps aTH -F` and `ps a -F`

also with fork event, it can totally avoid add such a patch in kernel.

Thanks.
>
> Also, last time I tried to change one of these stupid tracepoints
> userspace broke.. Rostedt says people should be using libtraceevent but
> I'm sceptical.
>
>>> Change-Id: Ia99f58a56d691d770b3beb2f76de0351e6194a4a
> That needs to die.

