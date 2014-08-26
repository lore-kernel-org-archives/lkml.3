Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbaHZBiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 21:38:51 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:58066 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbaHZBit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 21:38:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAMEtUuxdQpkX8t1_szde=Q1ALcp5t7rRyK+zEDafj27_J2LzVg@mail.gmail.com>
References: <1409014858-1410-1-git-send-email-ast@plumgrid.com>
 <1409014858-1410-2-git-send-email-ast@plumgrid.com> <20140825.180621.1003932711320755950.davem@davemloft.net>
 <CAMEtUuxdQpkX8t1_szde=Q1ALcp5t7rRyK+zEDafj27_J2LzVg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 25 Aug 2014 18:38:28 -0700
Message-ID: <CALCETrVgSXuRG_ZPXQt55ze7pHOCezU4Ev1KFUww6Yqk4JACgg@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 1/6] net: filter: add "load 64-bit immediate"
 eBPF instruction
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: David Miller <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 6:35 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> On Mon, Aug 25, 2014 at 6:06 PM, David Miller <davem@davemloft.net> wrote:
>> From: Alexei Starovoitov <ast@plumgrid.com>
>> Date: Mon, 25 Aug 2014 18:00:53 -0700
>>
>>> add BPF_LD_IMM64 instruction to load 64-bit immediate value into a register.
>>
>> I think you need to rethink this.
>>
>> I understand that you want to be able to compile arbitrary C code into
>> eBPF, but you have to restrict strongly what data the eBPF code can get
>> to.
>
> I believe verifier already does restrict it. I don't see any holes in
> the architecture. I'm probably not explaining it clearly though :(
>
>> Arbitrary pointer loads is asking for trouble.
>
> Of course.
> There is no arbitrary pointer from user space.
> Verifier checks all pointers.
> I guess this commit log description is confusing.
> It says:
> BPF_LD_IMM64(R1, const_imm_map_ptr)
> that's what appears in the program _after_ it goes through verifier.
> User space cannot pass a pointer into the kernel.

If you don't intend for userspace to load a program that contains this
instruction, then why does it need to be an instruction that the
verifier rewrites?  Why not have an instruction "load immediate
relocated pointer" that contains a reference to a relocation table and
have the JIT do it?  That might be easier to understand than having
the verifier do it, and it'll avoid committing to ABIs before we need
them.

--Andy
