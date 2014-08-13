Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaHMReE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:34:04 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:47460 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbaHMReB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:34:01 -0400
MIME-Version: 1.0
In-Reply-To: <53EB2D31.8090204@redhat.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
	<1407916658-8731-2-git-send-email-ast@plumgrid.com>
	<53EB2D31.8090204@redhat.com>
Date: Wed, 13 Aug 2014 10:34:00 -0700
Message-ID: <CAMEtUuzo6xQkhg+y0h_WEArVZi9cxVoGAcTBDcwMXza+eQGBTw@mail.gmail.com>
Subject: Re: [PATCH RFC v4 net-next 01/26] net: filter: add "load 64-bit
 immediate" eBPF instruction
From: Alexei Starovoitov <ast@plumgrid.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 2:17 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
> On 08/13/2014 09:57 AM, Alexei Starovoitov wrote:
>>
>> add BPF_LD_IMM64 instruction to load 64-bit immediate value into register.
>> All previous instructions were 8-byte. This is first 16-byte instruction.
>> Two consecutive 'struct bpf_insn' blocks are interpreted as single
>> instruction:
>> insn[0/1].code = BPF_LD | BPF_DW | BPF_IMM
>> insn[0/1].dst_reg = destination register
>> insn[0].imm = lower 32-bit
>> insn[1].imm = upper 32-bit
>>
>> Classic BPF has similar instruction: BPF_LD | BPF_W | BPF_IMM
>> which loads 32-bit immediate value into a register.
>>
>> x64 JITs it as single 'movabsq %rax, imm64'
>> arm64 may JIT as sequence of four 'movk x0, #imm16, lsl #shift' insn
>>
>> Note that old eBPF programs are binary compatible with new interpreter.
>>
>> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
>
>
> For follow-ups on this series, can you put the actual motivation
> for this change from the cover letter into this commit log as it
> otherwise doesn't say anything clearly why it is needed. Code and
> test case looks good to me.

ok. As you saw the full explanation is long, so I opted for 'it_does_this'
commit log. In the next rev will add more reasons to this log. Sure.
