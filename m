Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab3J1MRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:17:05 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38379 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab3J1MRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:17:03 -0400
Message-ID: <526E55B9.20902@hitachi.com>
Date: Mon, 28 Oct 2013 21:16:57 +0900
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
References: <20131024075813.GA26929@gmail.com> <CAGdX0WFu=sxWUckkZiUQMTxo_tOFbxX-paqU2p_5YR8NaN6gSA@mail.gmail.com> <20131025101511.GB3439@gmail.com> <CAGdX0WGrGbb-eJvS4HHg9umk7X3-vrzyrJCuhAJrfGvOriKHSQ@mail.gmail.com> <20131026085955.GD14237@gmail.com>
In-Reply-To: <20131026085955.GD14237@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/26 17:59), Ingo Molnar wrote:
> 
> * Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
> 
>> Thanks. An addition question I want to discuss in here is the ktap 
>> code structure layout in first patch series, this don't need to 
>> dig out any ktap design detail, so we can make agreement on this 
>> point, and ease for me to prepare patch series.
>>
>> Do I need to prepare patchset target on staging tree or "real" 
>> part of kernel? [...]
> 
> I'd suggest adding it to the core, i.e. kernel/tracing/ and 
> kernel/trace/trace_events_filter.c in particular which includes the 
> current filter script interpreter.

It means we'll need to put Lua compiler in the kernel...
I just recommend to put the ktap *on* the ftrace or perf. Not directly
integrate it. Bytecode interpreter is good, limited fomula parser is also
good, but IMHO, integrating complete lua compiler into the kernel looks
crazy.
I think it is just enough to include lua compiler as a tool in the kernel.

> (Please also make sure that the Lua copyright notices get carried 
> over properly.)
> 
>> [...] If target on driver/staging/ktap, then kernel code and 
>> userspace code still need to locate at same directory, that many 
>> people may don't like it.
>>
>> Target on "real" part kernel? - include/trace/ktap (header file 
>> common used by interpreter and userspace compiler) - 
>> kernel/trace/ktap (interpreter code, ktapvm, pure kernel module) - 
>> tools/perf/ktap?(userspace compiler code)
>>   As I also agree integrating ktap and perf together, two 
>>   subsystem can share many codes, so it's better putting ktap 
>>   userspace into perf directory.
> 
> Once there's a more split-out submission it will be easier to see 
> what belongs where. I agree with Pekka that for the user the UI 
> should be integrated and obvious.

But, what about perf script ? :)
ktap is for online scripting and perf-script is for offline scripting,
so both are worth to have, I think.

> I'd also like there to be a natural 'extract the script' 
> functionality from an installed tap script. This gives more 
> flexibiliy and improves security as well: no hidden, binary-only 
> crap, every script installed on a running system should be 
> extractable in source form, should be reviewable and modifiable.
> 

Would you mean the bytecode should be decodable? or loaded with
source code in the kernel?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


