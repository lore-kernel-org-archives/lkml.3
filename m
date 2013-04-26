Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab3DZQCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:02:47 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:53430 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3DZQCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:02:45 -0400
MIME-Version: 1.0
In-Reply-To: <1366989094.8964.212.camel@edumazet-glaptop>
References: <1366962706-24204-1-git-send-email-xi.wang@gmail.com>
 <1366962706-24204-3-git-send-email-xi.wang@gmail.com> <1366985926.8964.190.camel@edumazet-glaptop>
 <CAKU6vyZfYR-2408G0_Fkp-PS5x5rMH+s4_OOWqqi7Nt+UfiUPg@mail.gmail.com> <1366989094.8964.212.camel@edumazet-glaptop>
From: Xi Wang <xi.wang@gmail.com>
Date: Fri, 26 Apr 2013 12:02:04 -0400
Message-ID: <CAKU6vyav+4e1RTKnpNRUJ64TO9AJWy2n2yY4rC-PKiqLei0rfw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 2/6] x86: bpf_jit_comp: support
 BPF_S_ANC_SECCOMP_LD_W instruction
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@arm.linux.org.uk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Eric Dumazet <edumazet@google.com>, Will Drewry <wad@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 11:11 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 1) 'current' at the time the code is jitted (compiled) is not the
> 'current' at the time the filter will be evaluated.
>
> On x86_64, if CONFIG_IA32_EMULATION=y, syscall_get_arch() evaluates to :
>
> if (task_thread_info(task)->status & TS_COMPAT)
>         return AUDIT_ARCH_I386;
> return AUDIT_ARCH_X86_64;
>
> So your code is completely wrong.

Just to be clear, are you worrying about a process changing its
personality after installing seccomp filters?

- xi
