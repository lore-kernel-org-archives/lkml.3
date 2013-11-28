Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab3K1Cz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 21:55:57 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58225 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab3K1Czz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 21:55:55 -0500
Message-ID: <5296B0AA.9070207@hitachi.com>
Date: Thu, 28 Nov 2013 11:55:38 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC PATCH 0/2] tracing: Teach FETCH_MTD_symbol to handle per-cpu
 data
References: <20131123201543.GA22148@redhat.com> <20131125172106.GA14516@redhat.com> <20131125172206.GD14516@redhat.com> <52946B42.40603@hitachi.com> <20131126174355.GB14028@redhat.com> <5295C304.1050702@hitachi.com> <20131127174117.GC26138@redhat.com>
In-Reply-To: <20131127174117.GC26138@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/28 2:41), Oleg Nesterov wrote:
> On 11/27, Masami Hiramatsu wrote:
>>
>> (2013/11/27 2:43), Oleg Nesterov wrote:
>>>
>>> This doesn't allow to read the data from other CPUs, but at least
>>> the changes are simple and this_cpu_ is better than the reading
>>> from the obviously wrong address.
>>
>> Yeah, usually per_cpu variable is used in current cpu context.
>>
>>>> For the dynamic allocated per-cpu things, it is also good to give
>>>> a straight operation, like +10(percpu(%rdi)).
>>>
>>> Probably yes, but this needs more changes and I am still not sure
>>> this is really useful. And if we do this, we probably also need
>>> to allow to read from other CPUs...
>>
>> No, it is enough to provide "percpu(FETCHARG)" which just returns
>> current cpu's percpu variable address.
> 
> I don't really agree. I am not saying this is terribly useful, but:
> 
>> (Note that kprobes handler
>> runs in interrupt)
> 
> but this doesn't matter at all, I think. The code can execute, say,
> __percpu_counter_sum-like code.
>
> And even if we dump the .data..percpu memory (@percpu_symbol) the
> user might want to know the "global" state of this per-cpu object.

I see, but it is the problem solved in the next step.
IMHO, giving people to access just to this cpu's variable is enough
useful. Expanding it to other cpu is another one.

> And note that sometimes DEFINE_PER_CPU doesn't really connect to
> smp_processor_id(). Just for example, bp_cpuinfo[]. It is never
> used as this-cpu-data. This means that @bp_cpuinfo+whatever is
> always pointless.

Yeah, there should be some exceptions.

> But anyway I agree, this is not that important, lets ignore.

 :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


