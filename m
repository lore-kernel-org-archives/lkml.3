Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab3DXLQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:16:46 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:35505 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab3DXLQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:16:44 -0400
Message-ID: <5177BEA9.2030207@huawei.com>
Date: Wed, 24 Apr 2013 19:14:49 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/14] perf tools: Introduce new 'ftrace' command
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org> <1366732681.9609.157.camel@gandalf.local.home> <87ip3cb7nu.fsf@sejong.aot.lge.com>
In-Reply-To: <87ip3cb7nu.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/24 17:27, Namhyung Kim wrote:
> Hi Steve,
> 
> On Tue, 23 Apr 2013 11:58:01 -0400, Steven Rostedt wrote:
>> On Tue, 2013-04-23 at 17:30 +0900, Namhyung Kim wrote:
>>> Hello,
>>>
>>> This patchset implements a front-end tool for kernel's ftrace.  It
>>> uses function_graph tracer by default and normal function tracer is
>>> also supported.  (Of course you need to enable those tracers in your
>>> kernel first.)
>>>
>>> NOTE: It's in very early stage, so may contain many rough edges.
>>>
>>
>> Very nice Namhyung, thanks for doing this. I did a quick run through of
>> the patches and I have no complaints about them. I'm not sure how the
>> others will feel about it.
> 
> Thanks!
> 
>>
>> Also, have you given thought on how to execute both ftrace and the pmu
>> counters? That is, to get a way to interleave the data?
> 
> I didn't think about it yet.  I just thought enabling event tracing in
> ftrace and get the data along with the function tracing.  I'm not sure
> how they interfere each other when enabled at the same time.
> 
> If that's not a valid concern, I think it's doable.

There have ftrace:function event in tracing infrastructure, that event works in perf,
but I'm not sure if it could enhance to showing function graph as this patchset did.
	perf record -e ftrace:function ls > /dev/null
	perf report

> 
> 
>> I added a 'perf' clock to ftrace. I didn't see that being checked,
>> although I didn't look too hard. If possible, you can use that, as well
>> as the multi-buffers that are coming in 3.10.
> 
> Will look at it later.
> 
>>
>> I would also like to add a system call to allow you to get to the ftrace
>> data without the need for debugfs. I'm not sure if we should piggy back
>> on the perf system call, or add a new one. I'm thinking we should add a
>> new one so that it doesn't get too confusing.
> 
> Could you elaborate on it more?  I cannot see how it'll look like..
> 
>>
>> Hope others have comments,
> 
> Thanks for your kind review.
> Namhyung
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> .
> 


