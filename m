Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbaHNTRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 15:17:42 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:56642 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbaHNTRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 15:17:40 -0400
MIME-Version: 1.0
In-Reply-To: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
Date: Thu, 14 Aug 2014 12:17:39 -0700
Message-ID: <CAE40pdcsEnCg-zVyYR-hkYZ9Zd4kmX2BS11cFWAKZK3=HfBUMg@mail.gmail.com>
Subject: Re: [PATCH RFC v4 net-next 00/26] BPF syscall, maps, verifier,
 samples, llvm
From: Brendan Gregg <brendan.d.gregg@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 12:57 AM, Alexei Starovoitov <ast@plumgrid.com> wrote:
[...]
> Tracing use case got some improvements as well. Now eBPF programs can be
> attached to tracepoint, syscall, kprobe and C examples are more usable:
> ex1_kern.c - demonstrate how programs can walk in-kernel data structures
> ex2_kern.c - in-kernel event accounting and user space histograms
> See patch #25

This is great, thanks! I've been using this new support, and
successfully ported an an older tool of mine (bitesize) to eBPF. I was
using the block:block_rq_issue tracepoint, and performing a custom
in-kernel histogram, like in the ex2_kern.c example, for I/O size.

I also did some quick overhead testing and found eBPF with JIT to be
relatively fast. (I'd share numbers but it's platform specific.) The
syscall tracepoints were a bit slower than hoped, for what I think is
a well known issue.

Are there thoughts in general for how this might be used for embedded
devices, where installing clang/llvm might be prohibitive? Compile on
another system and move the binaries over? thanks,

Brendan
