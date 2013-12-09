Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221Ab3LIKMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:12:15 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58971 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab3LIKMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:12:13 -0500
Message-ID: <52A59775.9050206@hitachi.com>
Date: Mon, 09 Dec 2013 19:12:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC PATCH tip 4/5] use BPF in tracing filters
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com> <1386044930-15149-5-git-send-email-ast@plumgrid.com> <529E7BEC.70509@hitachi.com> <20131203201133.52934a02@gandalf.local.home> <529FC352.7090004@hitachi.com> <CAMEtUuwMv6PtN=9_RmxouZpVB8PVN8oZDNDUyLva2J+xos48og@mail.gmail.com> <52A18E31.6030605@hitachi.com> <CAGdX0WGK13RVo6dgNbMKm81gy4GLZUBFEhmYfHj6tjz33FpmnQ@mail.gmail.com> <52A26268.5070403@hitachi.com> <y0m38m3qk23.fsf@fche.csb>
In-Reply-To: <y0m38m3qk23.fsf@fche.csb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/09 3:22), Frank Ch. Eigler wrote:
> 
> masami.hiramatsu.pt wrote:
> 
>> [...]
>> Anyway, as far as I can see, there looks be two different models of
>> tracing in our mind.
>>
>> A) Fixed event based tracing: In this model, there are several fixed
>> "events" which well defined with fixed arguments. tracer handles these
>> events and only use limited arguments. It's like a packet stream
>> processing. ftrace, perf etc. are used this model.
>>
>> B) Flexible event-point tracing: In this model, each tracer(or even
>> trace user) can freely define their own event, there will be some fixed
>> tracing points defined, but arguments are defined by users. It's like a
>> debugger's breakpoint debugging. systemtap, ktap etc. are used this model.
> 
> It may be more useful to think of it as a contrast along the
> hard-coded versus programmable axis.  (perf, systemtap, and ktap can
> each reach to some extent across your "fixed" vs "flexible" line.
> Each has some dynamic and some static-tracepoint capability.)

Oh, I meant that B is not tend to share the defined event among
different tracing instances. Each instances defines new different
dynamic events and gets memories and registers freely.
OTOH, the Ftrace and LTT models are based on the fixed, shared
and well defined events. Even if a new dynamic event is defined,
it will be shared by every instances.

> 
>> e.g. B model has a good flexibility and A model is easy to use for
>> beginners.
> 
> I don't think it's the model that dictates ease-of-use, but the
> quality of implementation, logistics, documentation, and examples.

Of course, but it requires learning the new programming way. And
also, we need to know about the target source code for setting up
new events. I know that the systemtap provides many pre-defined
probepoints. so, the systemtap may already have solved this kind of
issue. ;)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


