Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbaH2Rjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:39:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbaH2Rj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:39:29 -0400
Message-ID: <5400BAB7.80001@redhat.com>
Date: Fri, 29 Aug 2014 19:39:03 +0200
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
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 net-next 2/2] net: filter: split filter.h and expose
 eBPF to user space
References: <1409171833-6979-1-git-send-email-ast@plumgrid.com> <1409171833-6979-3-git-send-email-ast@plumgrid.com>
In-Reply-To: <1409171833-6979-3-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 10:37 PM, Alexei Starovoitov wrote:
> allow user space to generate eBPF programs
>
> uapi/linux/bpf.h: eBPF instruction set definition
>
> linux/filter.h: the rest

Very sorry for being late, but just a thought since we're touching user
space headers anyway ...

Wouldn't it be more consistent to have it organized as follows ...

  - uapi/linux/bpf.h    : classic BPF instruction set parts only
  - uapi/linux/ebpf.h   : eBPF instruction set definition (which also
                          includes uapi/linux/bpf.h though)
... and have ...

  - uapi/linux/filter.h : just include uapi/linux/bpf.h but rest is empty

That way, it would be more consistent ...

Old legacy application can stay with linux/filter.h; new applications
based on their needs can choose between linux/{e,}bpf.h and in the kernel,
we can just include linux/ebpf.h.

Right now, it seems, an eBPF user space program would need to include
2 header files in user space (linux/filter.h, linux/bpf.h) which I find
a bit confusing.

If you want, I could also take care of that later, but just thinking out
loudly ...

> This patch only moves macro definitions, but practically it freezes existing
> eBPF instruction set, though new instructions can still be added in the future.
>
> These eBPF definitions cannot go into uapi/linux/filter.h, since the names
> may conflict with existing applications.
>
> Full eBPF ISA description is in Documentation/networking/filter.txt
>
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
