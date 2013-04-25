Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab3DYFx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 01:53:56 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51685 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3DYFxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 01:53:55 -0400
X-AuditID: 9c930197-b7bb3ae000000fa9-80-5178c4effb46
From: Namhyung Kim <namhyung@kernel.org>
To: "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/14] perf tools: Introduce new 'ftrace' command
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
	<1366732681.9609.157.camel@gandalf.local.home>
	<CAOJsxLF16Edznsdis4NK-O1Sf=3Eswb5L=cfBDhjpr6F7UjTbg@mail.gmail.com>
	<20130424065018.GC27551@gmail.com> <87a9oob6i2.fsf@sejong.aot.lge.com>
	<5177BEC7.4020906@huawei.com>
Date: Thu, 25 Apr 2013 14:53:51 +0900
In-Reply-To: <5177BEC7.4020906@huawei.com> (zhangwei's message of "Wed, 24 Apr
	2013 19:15:19 +0800")
Message-ID: <87obd39mvk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013 19:15:19 +0800, zhangwei wrote:
> On 2013/4/24 17:52, Namhyung Kim wrote:
>> I think it'd be great if perf trace can cover both of kernel and user
>> spaces.  But function tracing in userspace looks impossible IMHO.
>> 
>> So how about changing perf trace to receive proposed sub-commands
>> (live/record/show/report) and following options:
>> 
>>   --kernel::	do ftrace (for kernel functions)
>>   --syscall::	do system call tracing (what perf trace does now)
>> 
> "--kernel" make me think it's will trace all event tracepoints, not only ftrace.

Well, I'm not sure what's the right name.  --kernel-function?

>
> for "--syscall" option, I always think we should enhance syscall tracing more than now,
> like use annotate info when parse syscall event in perf, as other tracepoint does.
> we also need read filename user string in kernel space when open syscall tracepoint hit,
> record in perf.data, then perf parse it. After these functionality is implemented,
> we will don't need a separate syscall tracing tool in perf any more,
> just use: perf record -e "syscalls:" -a

It's a different story.  But I do think it'd better if there's a way to
see some of userspace strings like this.

Thanks,
Namhyung
