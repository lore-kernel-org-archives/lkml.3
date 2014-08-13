Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaHMJSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:18:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbaHMJSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:18:07 -0400
Message-ID: <53EB2D31.8090204@redhat.com>
Date: Wed, 13 Aug 2014 11:17:37 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v4 net-next 01/26] net: filter: add "load 64-bit immediate"
 eBPF instruction
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com> <1407916658-8731-2-git-send-email-ast@plumgrid.com>
In-Reply-To: <1407916658-8731-2-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 09:57 AM, Alexei Starovoitov wrote:
> add BPF_LD_IMM64 instruction to load 64-bit immediate value into register.
> All previous instructions were 8-byte. This is first 16-byte instruction.
> Two consecutive 'struct bpf_insn' blocks are interpreted as single instruction:
> insn[0/1].code = BPF_LD | BPF_DW | BPF_IMM
> insn[0/1].dst_reg = destination register
> insn[0].imm = lower 32-bit
> insn[1].imm = upper 32-bit
>
> Classic BPF has similar instruction: BPF_LD | BPF_W | BPF_IMM
> which loads 32-bit immediate value into a register.
>
> x64 JITs it as single 'movabsq %rax, imm64'
> arm64 may JIT as sequence of four 'movk x0, #imm16, lsl #shift' insn
>
> Note that old eBPF programs are binary compatible with new interpreter.
>
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>

For follow-ups on this series, can you put the actual motivation
for this change from the cover letter into this commit log as it
otherwise doesn't say anything clearly why it is needed. Code and
test case looks good to me.
