Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3J1Fsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 01:48:35 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51011 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab3J1Fsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 01:48:32 -0400
Message-ID: <526DFAAC.9070409@hitachi.com>
Date: Mon, 28 Oct 2013 14:48:28 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZQ==?= =?UTF-8?B?aXNiZWNrZXI=?= 
	<fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Re: ktap inclusion in drivers/staging/?
References: <20131024075813.GA26929@gmail.com> <CAGdX0WFu=sxWUckkZiUQMTxo_tOFbxX-paqU2p_5YR8NaN6gSA@mail.gmail.com> <20131025101511.GB3439@gmail.com>
In-Reply-To: <20131025101511.GB3439@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/25 19:15), Ingo Molnar wrote:
> 
> * Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
> 
>> Hi Ingo,
>>
>> On Thu, Oct 24, 2013 at 3:58 PM, Ingo Molnar <mingo@kernel.org> wrote:
>>>
>>> Greg,
>>>
>>> I was surprised to see 'ktap' appear in the staging tree silently,
>>> via these commits that are visible in today's staging-next:
>>>
>>>  2c856b9e3e06 staging: ktap: remove unused <asm/syscall.h> header file
>>>  687b63a3bfd5 staging: ktap: update email name in MAINTAINERS
>>>  c63a164271f8 staging: ktap: add to the kernel tree
>>>
>>> ktap is pretty fresh instrumentation code, announced on lkml a
>>> couple of months ago, and so far I haven't seen much technical
>>> discussion of integrating ktap upstream, mostly I suspect because
>>> not a _single_ patch was sent to linux-kernel for review. (!)
>>>
>> I accept Greg revert this in staging-next tree, It's entirely my fault, sorry.
> 
> Thanks!
> 
>>> An announcement of a Git tree was made (which Git tree is not very
>>> structured), and some very minimal discussion ensued, but no actual
>>> patches were sent with an intent to merge, no technical arguments
>>> were made in favor of merging and nothing conclusive was achieved.
>>>
>>> A couple of very quick (and incomplete) technical objections:
>>>
>>>  - The Git commits in staging an absolutely unstructured,
>>>    unreviewable mess, due to a single commit adding 16 KLOCs (!) of
>>>    code:
>>>
>>>       80 files changed, 16376 insertions(+)
>>>
>>>    (I looked at the ktap Git tree as well, it's not much better.)
>>>
>>>  - Most of the kernel code comes with near zero explanations in the
>>>    code itself. I looked at the kernel code in
>>>    drivers/staging/ktap/interpreter/.  I have not found a _single_
>>>    substantial in-code comment about design details and
>>>    implementational considerations. (!!)
>>>
>> I will add more comments for it, also will draft a design detail in
>> doc/ directory.
>>
>>>  - From the little I've been able to decode I get the impression
>>>    that the design should be much more integrated into the rest of
>>>    instrumentation: the in-kernel Lua bytecode interpreter looks
>>>    interesting, it could be an intelligent upgrade (or even outright
>>>    replacement) for the current 'filter' interpreter concept we have
>>>    for tracepoints - instead of putting a parallel interpreter
>>>    implementation into the kernel.

Hmm, IMHO, the current simple filter itself is not needed to be merged
at least ftrace side, since the ktap filter requires userspace compiler
on the other hand ftrace does it directly by debugfs.
Perhaps, after the bytecode generator and JIT compiler is introduced,
we can pass filter rules to the generator via debugfs.

>>>  - In a similar fashion, it would be nice to see it integrated with
>>>    'perf probe' or 'perf ktap', so that users can create probes from
>>>    a single place, with coherent syntax and integrated analysis
>>>    capabilities. I.e. there's no reason to not make this a
>>>    relatively pain-less yet very useful transition.
>>
>> Yes, I also mentioned this in my RFC email post before, that's the 
>> reason why I use perf-like interface in ktap as much as I can, 
>> like perf-tracepoints and perf-probe, also ktap can reuse perf 
>> debuginfo handling code in future, we are on the same page at this 
>> technical point.
> 
> Okay, cool! I've also Cc:-ed Masami, who was also very receptive in 
> person of the idea to merge this kind of scripting into perf probe.

Yeah, that is what I recommend him. If ktap uses directly perf
tools, it will simplify its design (compared with systemtap...)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


