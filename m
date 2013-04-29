Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab3D2HtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 03:49:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35359 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab3D2HtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 03:49:10 -0400
MIME-Version: 1.0
In-Reply-To: <1367112092.8964.294.camel@edumazet-glaptop>
References: <1367029047-14830-1-git-send-email-xi.wang@gmail.com>
 <1367029047-14830-3-git-send-email-xi.wang@gmail.com> <1367112092.8964.294.camel@edumazet-glaptop>
From: Xi Wang <xi.wang@gmail.com>
Date: Mon, 29 Apr 2013 03:48:29 -0400
Message-ID: <CAKU6vyaWgj4kKq0pBUYHa2hDMDOgtVghCWqpaD7riVe+KduOUA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 2/3] x86: bpf_jit_comp: support
 BPF_S_ANC_SECCOMP_LD_W instruction
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Borkmann <dborkman@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Will Drewry <wad@chromium.org>, Eric Dumazet <edumazet@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Laight <david.laight@aculab.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Schichan <nschichan@freebox.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 9:21 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> I would feel more comfortable if you added :
>
>         if (seen & SEEN_DATAREF) {
>                 pr_err_once("SECCOMP_LD_W assertion failed\n"):
>                 goto out;
>         }
>
> This way, if BPF is changed in the future, but not the x86 JIT, we
> can have a working kernel.
>
> Ideally, we should add a SEEN_SKBREF to make sure rdi value can be
> scratched, or you just push %rdi/pop %rdi, its only one byte
> instructions.

Adding SEEN_SKBREF sounds like a good idea. :)

> Or completely optimize the thing and not call seccomp_bpf_load() at all.

This would be cool.

> (current would be loaded once in r9, task_pt_regs() would be loaded once
> in r8)

Both syscall_get_arch() and syscall_get_arguments() need to test for
the TS_COMPAT bit (in task_thread_info(current)->status); we should
load that once, too.

Thanks for the comments.  Will try a v3.

- xi
