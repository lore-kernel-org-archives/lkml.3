Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaIJLZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 07:25:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbaIJLZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 07:25:30 -0400
Message-ID: <54103506.1030501@redhat.com>
Date: Wed, 10 Sep 2014 13:24:54 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 net-next 11/12] net: filter: move eBPF instruction
 macros
References: <1410325808-3657-1-git-send-email-ast@plumgrid.com> <1410325808-3657-12-git-send-email-ast@plumgrid.com>
In-Reply-To: <1410325808-3657-12-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 07:10 AM, Alexei Starovoitov wrote:
> move instruction macros (like BPF_MOV64_REG or BPF_ALU32_IMM)
> from linux/filter.h into uapi/linux/bpf.h
> so that userspace programs can use them.
>
> verifier testsuite (in later patches) will be using them.
>
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>

I don't think we need this commit at all. These macros are not really
part of the ABI and we should expose __as less as possible__, otherwise
we won't be able to alter them anymore. Plus, based on your previous
argumentation regarding the header file expose, we also won't be able
to add any new macros anymore since you could run into name collisions.

Anyway, I don't see a reason why a e.g. central user space eBPF library
cannot live with, for example, a private copy of these helper macros or
whatever it wants to define by itself.

I know in classic BPF there's BPF_STMT() and BPF_JUMP() but it's much
less complicated than eBPF and less likely to changes.
