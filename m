Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaHMXfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 19:35:22 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:37044 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaHMXfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 19:35:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140813.162516.1876660483788283579.davem@davemloft.net>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
 <063D6719AE5E284EB5DD2968C1650D6D174760F3@AcuExch.aculab.com> <20140813.162516.1876660483788283579.davem@davemloft.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 13 Aug 2014 16:34:59 -0700
Message-ID: <CALCETrV4u3jup3pRjEJiPcvccvH84bYykLYxCCU7ek7yprt+Fg@mail.gmail.com>
Subject: Re: [PATCH RFC v4 net-next 00/26] BPF syscall, maps, verifier,
 samples, llvm
To: David Miller <davem@davemloft.net>
Cc: David Laight <David.Laight@aculab.com>,
        Alexei Starovoitov <ast@plumgrid.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 4:25 PM, David Miller <davem@davemloft.net> wrote:
> From: David Laight <David.Laight@ACULAB.COM>
> Date: Wed, 13 Aug 2014 08:52:30 +0000
>
>> From: Of Alexei Starovoitov
>>> one more RFC...
>>>
>>> Major difference vs previous set is a new 'load 64-bit immediate' eBPF insn.
>>> Which is first 16-byte instruction. It shows how eBPF ISA can be extended
>>> while maintaining backward compatibility, but mainly it cleans up eBPF
>>> program access to maps and improves run-time performance.
>>
>> Wouldn't it be more sensible to follow the scheme used by a lot of cpus
>> and add a 'load high' instruction (follow with 'add' or 'or').
>> It still takes 16 bytes to load a 64bit immediate value, but the instruction
>> size remains constant.
>> There is nothing to stop any JIT software detecting the instruction pair.
>
> The opposite argument is that JITs can expand the IMM64 load into whatever
> sequence of instructions is most optimal.
>
> My only real gripe with IMM64 loads is that it's not mainly for
> loading an immediate, it's for loading a pointer.  And this
> distinction is important for some JITs.
>
> For example, on sparc64 all symbol based addresses are actually 32-bit
> because of the code model we use to compile the kernel and all modules.
> So if we knew this is a pointer load and it's to a symbol in a kernel
> or module image, we could do a 32-bit load.

This is true for x86_64 as well, I think.

(Almost.  For x86_64 we have a choice between a sign-extended load of
a value in the top 2GB of the address space and lea reg,offset(%rip).)

--Andy
