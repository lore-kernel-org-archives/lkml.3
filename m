Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbaH2XBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 19:01:34 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:38893 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaH2XBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 19:01:32 -0400
MIME-Version: 1.0
In-Reply-To: <5400FDA0.7000704@redhat.com>
References: <1409171833-6979-1-git-send-email-ast@plumgrid.com>
	<1409171833-6979-3-git-send-email-ast@plumgrid.com>
	<5400BAB7.80001@redhat.com>
	<CAADnVQJbgiUK1vt_SDEG6Yee-Ht67e2M82PrHb3Kx533BOF-rg@mail.gmail.com>
	<5400FDA0.7000704@redhat.com>
Date: Fri, 29 Aug 2014 16:01:30 -0700
Message-ID: <CAMEtUuyRUujYhRsH9aUx0h7wvU1DrKRHNWZtoOYEgHVfKdCTxw@mail.gmail.com>
Subject: Re: [PATCH v8 net-next 2/2] net: filter: split filter.h and expose
 eBPF to user space
From: Alexei Starovoitov <ast@plumgrid.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 3:24 PM, Daniel Borkmann <dborkman@redhat.com> wrote:
>>
>> Also I really dislike 'ebpf' name in all lower case. If we make such
>> header
>> file name, we would need to rename all macros and function names
>> to EBPF_... which I find very ugly looking. I think all good abbreviations
>> are
>> three letters :)
>
>
> I don't think we would have to name defines that way, really, that would be
> terrible. We can keep them simply *as is*. Not sure though why bpf.h +
> ebpf.h
> would be that bad. ;) I haven't tried it out yet, but if we would indeed run
> into a name collision, above proposal would resolve that.

imo it's a consistency issue. If main uapi header is ebpf.h then
corresponding kernel internal header should be ebpf.h as well
and kernel/ebpf/ directory and so on.
That's why I insist on uapi/linux/bpf.h and no other name.
Note I didn't move any of the BPF_ALU64_REG, BPF_ALU32_IMM
macros from linux/filter.h. Without them my verifier testsuite
won't compile, so more lines would be added to bpf.h in the future.
At that time we can take 45 lines out of uapi/linux/filter.h and move
them into bpf_common.h. My request is let's not fight about it
right now. We didn't even cross the bridge yet and arguing
about beauty of user apps that come in 30 patches from now...

These two patches are about _intent_ of making eBPF usable
from userspace, so I can move along with llvm.
Also worth noting that llmv will not be including this uapi/linux/bpf.h
It has its own infra to generate instructions. Look at:
tools/bpf/llvm/lib/Target/BPF/BPFInstrInfo.td
it's a special 'table definition' language for describing bits and fields
of instructions.
So these two patches are mainly establishing _intent_ and bpf.h file
name. That's why I'm so paranoid about naming.

btw, I've spent last two days writing syscall manpage :(
What is the best way to present it for review?
If I just attach it raw, it's unreadable... I can include a link
to html page, but man2html produces ugly pages comparing
to what 'man' command shows. Any nice man converters
that generate stuff seen on man7.org ?
