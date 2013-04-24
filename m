Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab3DXLRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:17:16 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:26084 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab3DXLRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:17:15 -0400
Message-ID: <5177BEC7.4020906@huawei.com>
Date: Wed, 24 Apr 2013 19:15:19 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/14] perf tools: Introduce new 'ftrace' command
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org> <1366732681.9609.157.camel@gandalf.local.home> <CAOJsxLF16Edznsdis4NK-O1Sf=3Eswb5L=cfBDhjpr6F7UjTbg@mail.gmail.com> <20130424065018.GC27551@gmail.com> <87a9oob6i2.fsf@sejong.aot.lge.com>
In-Reply-To: <87a9oob6i2.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/24 17:52, Namhyung Kim wrote:
> Hi Ingo,
> 
> On Wed, 24 Apr 2013 08:50:18 +0200, Ingo Molnar wrote:
>> * Pekka Enberg <penberg@kernel.org> wrote:
>>
>>> Hello,
>>>
>>> On Tue, 2013-04-23 at 17:30 +0900, Namhyung Kim wrote:
>>>>> This patchset implements a front-end tool for kernel's ftrace.  It
>>>>> uses function_graph tracer by default and normal function tracer is
>>>>> also supported.  (Of course you need to enable those tracers in your
>>>>> kernel first.)
>>>
>>> On Tue, Apr 23, 2013 at 6:58 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>>> Very nice Namhyung, thanks for doing this. I did a quick run through of
>>>> the patches and I have no complaints about them. I'm not sure how the
>>>> others will feel about it.
>>>
>>> I also skimmed through the patches and they look like a reasonable
>>> starting point. So FWIW,
>>>
>>> Acked-by: Pekka Enberg <penberg@kernel.org>
>>>
>>> Are there any plans in trying to consolidate 'perf trace' and this? As
>>> a user I don't really care what the underlying mechanism and would
>>> like things to just work out of the box.
>>
>> Exactly. I'd love to see ftrace and perf trace unified.
>>
>> I have no objections against having a 'perf ftrace' interim step - as long 
>> as it's really a temporary migration construct, not something we intend to 
>> keep forever.
> 
> Hmm.. okay.
> 
> I think it'd be great if perf trace can cover both of kernel and user
> spaces.  But function tracing in userspace looks impossible IMHO.
> 
> So how about changing perf trace to receive proposed sub-commands
> (live/record/show/report) and following options:
> 
>   --kernel::	do ftrace (for kernel functions)
>   --syscall::	do system call tracing (what perf trace does now)
> 
"--kernel" make me think it's will trace all event tracepoints, not only ftrace.

for "--syscall" option, I always think we should enhance syscall tracing more than now,
like use annotate info when parse syscall event in perf, as other tracepoint does.
we also need read filename user string in kernel space when open syscall tracepoint hit,
record in perf.data, then perf parse it. After these functionality is implemented,
we will don't need a separate syscall tracing tool in perf any more,
just use: perf record -e "syscalls:" -a
> 
> But I think we need to have an agreement on the file/directory format to
> support multiple recorder threads first.  Any comments on this issue?
> 
> Thanks,
> Namhyung
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> .
> 


