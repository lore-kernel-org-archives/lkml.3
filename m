Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097Ab3LIJwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:52:09 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:45007 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab3LIJwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:52:05 -0500
Message-ID: <52A592BD.9090304@hitachi.com>
Date: Mon, 09 Dec 2013 18:51:57 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Alexei Starovoitov <ast@plumgrid.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlz?= =?UTF-8?B?YmVja2Vy?= 
	<fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>, Pekka Enberg <penberg@iki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Arjan van de Ven <arjan@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com> <20131203091655.GB20179@gmail.com> <20131203103346.65c744e3@gandalf.local.home> <CAMEtUuw_6dCuZd=1fQxNYrZid67n7MRYBT16qBkgR_JxOPkfdg@mail.gmail.com> <529E81C1.2070208@hitachi.com> <877gbemqhf.fsf@sejong.aot.lge.com>
In-Reply-To: <877gbemqhf.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/09 16:29), Namhyung Kim wrote:
> Hi Masami,
> 
> On Wed, 04 Dec 2013 10:13:37 +0900, Masami Hiramatsu wrote:
>> (2013/12/04 3:26), Alexei Starovoitov wrote:
>>> the only inconvenience so far is to know how parameters are getting
>>> into registers.
>>> on x86-64, arg1 is in rdi, arg2 is in rsi,... I want to improve that
>>> after first step is done.
>>
>> Actually, that part is done by the perf-probe and ftrace dynamic events
>> (kernel/trace/trace_probe.c). I think this generic BPF is good for
>> re-implementing fetch methods. :)
> 
> For implementing patch method, it seems that it needs to access to user
> memory, stack and/or current (task_struct - for utask or vma later) from
> the BPF VM as well.  Isn't it OK from the security perspective?

Would you mean security or safety?  :)
For safety, I think we can check the BPF binary doesn't break anything.
Anyway, for fetch method, I think we have to make a generic syntax tree
for the archs which don't support BPF, and BPF bytecode will be generated
by the syntax tree. IOW, I'd like to use BPF just for optimizing
memory address calculation.
For security, it is hard to check what is the sensitive information
in the kernel, I think it should be restricted to root user a while.

> Anyway, I'll take a look at it later if I have time, but I want to get
> the existing/pending implementation merged first. :)

Yes, of course ! :)

Thank you,
-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


