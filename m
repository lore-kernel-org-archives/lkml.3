Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab3LGQxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 11:53:16 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:37226 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296Ab3LGQxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 11:53:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAMEtUuyBRTsP59+g_qCxxFs=dzP+1ZJwBv+4=znxkJcyi3RBRA@mail.gmail.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<87fvq9cwlk.fsf@tassilo.jf.intel.com>
	<CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com>
	<CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
	<20131206001454.GB21717@two.firstfloor.org>
	<52A12421.2040208@zytor.com>
	<871u1qwzae.fsf@tassilo.jf.intel.com>
	<CAMEtUuyBRTsP59+g_qCxxFs=dzP+1ZJwBv+4=znxkJcyi3RBRA@mail.gmail.com>
Date: Sun, 8 Dec 2013 00:53:12 +0800
Message-ID: <CAGdX0WHVGMSm8cSxbGSzCObKQYvZqFANwiZCkPfOOgeS0yj7MQ@mail.gmail.com>
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 7, 2013 at 9:12 AM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> On Thu, Dec 5, 2013 at 5:20 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> "H. Peter Anvin" <hpa@zytor.com> writes:
>>>
>>> Not to mention that in that case we might as well -- since we need a
>>> compiler anyway -- generate the machine code in user space; the JIT
>>> solution really only is useful if it can provide something that we can't
>>> do otherwise, e.g. enable it in secure boot environments.
>>
>> I can see there may be some setups which don't have a compiler
>> (e.g. I know some people don't use systemtap because of that)
>> But this needs a custom gcc install too as far as I understand.
>
> fyi custom gcc is a single 13M binary. It doesn't depend on any
> include files or any libraries.
> and can be easily packaged together with perf... even for embedded environment.

Hmm, 13M binary is big IMO, perf is just 5M after compiled in my system,
I'm not sure embed a custom gcc into perf is a good idea. (and need to
compile that custom gcc every time when build perf ?)

IMO gcc size is not all/main reason of why embedded system didn't
install it, I saw many many production embedded system, no one
install gcc, also gdb, etc. I would never expect Android will install
gcc in some day, I also will really surprise if telcom-vender deliver
Linux board with gcc installed to customers.

Another question is: does the custom gcc of bpf-filter need kernel
header file for compilation? if it need, then this issue is more bigger
than gcc size for embedded system.(same problem like Systemtap)

Thanks,

Jovi.
