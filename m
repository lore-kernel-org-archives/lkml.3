Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbbATKhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:37:31 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:43623 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbbATKh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:37:27 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Fam Zheng <famz@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Miklos Szeredi <mszeredi@suse.cz>,
        David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC 0/6] epoll: Introduce new syscall "epoll_mod_wait"
Organization: D03
References: <1421747878-30744-1-git-send-email-famz@redhat.com>
X-Hashcash: 1:20:150120:linux-fsdevel@vger.kernel.org::2Pn0siu7hh9XZCbc:0000000000000000000000000000000006NU
X-Hashcash: 1:20:150120:tytso@mit.edu::qYmF7df0YuvMct+7:000004e2
X-Hashcash: 1:20:150120:ast@plumgrid.com::0R8wWk9iUT2mPTHM:007yB
X-Hashcash: 1:20:150120:dh.herrmann@gmail.com::G9mq8wLYSh54UqwF:00000000000000000000000000000000000000000wMZ
X-Hashcash: 1:20:150120:mathieu.desnoyers@efficios.com::q9UZqykq8PFinO4B:00000000000000000000000000000001IXh
X-Hashcash: 1:20:150120:hpa@zytor.com::Oj97J9xpQLSJWmdu:00001Zr5
X-Hashcash: 1:20:150120:davem@davemloft.net::tG3y4eDCiSynmh2Z:0000000000000000000000000000000000000000001hmE
X-Hashcash: 1:20:150120:pbonzini@redhat.com::N/Vl1+zfg7MG//wk:0000000000000000000000000000000000000000001apG
X-Hashcash: 1:20:150120:rashika.kheria@gmail.com::7V1uSUKEPVi+je09:000000000000000000000000000000000000028nV
X-Hashcash: 1:20:150120:mszeredi@suse.cz::Onkll7XWdC4dVU8w:02Pfu
X-Hashcash: 1:20:150120:mingo@redhat.com::EBUtjGz+P0ObyZyh:02chy
X-Hashcash: 1:20:150120:linux-api@vger.kernel.org::OMeTmi1iPC9wRpUl:0000000000000000000000000000000000002USi
X-Hashcash: 1:20:150120:mtk.manpages@gmail.com::R6XH9rWzfZfP/KV6:0000000000000000000000000000000000000002X72
X-Hashcash: 1:20:150120:drysdale@google.com::cJ3zmdBBJofzyR0i:0000000000000000000000000000000000000000002kiy
X-Hashcash: 1:20:150120:peterz@infradead.org::qfI7c8ugeveJ38xa:0000000000000000000000000000000000000000036CN
X-Hashcash: 1:20:150120:hughd@google.com::IVDHNzv1D5dFxl7z:03D2y
X-Hashcash: 1:20:150120:keescook@chromium.org::0ILt7sXMCpB6s1uh:000000000000000000000000000000000000000048cr
X-Hashcash: 1:20:150120:tglx@linutronix.de::5lw6eHwUjQQpV0r7:00000000000000000000000000000000000000000003jh9
X-Hashcash: 1:20:150120:linux-kernel@vger.kernel.org::Ti8ckyQBXnRlRWxc:0000000000000000000000000000000004g13
X-Hashcash: 1:20:150120:oleg@redhat.com::bG48cw7ilALRGYp7:0058S3
X-Hashcash: 1:20:150120:viro@zeniv.linux.org.uk::A5FXdThwK4I0v0iZ:000000000000000000000000000000000000005apa
X-Hashcash: 1:20:150120:x86@kernel.org::eTw4DNt8j/t+HMCq:0005xZp
X-Hashcash: 1:20:150120:luto@amacapital.net::w4TIvVbysK+vC4Zh:0000000000000000000000000000000000000000005kXi
X-Hashcash: 1:20:150120:akpm@linux-foundation.org::b9+FDTt8fvGkYAYe:0000000000000000000000000000000000005pAU
X-Hashcash: 1:20:150120:heiko.carstens@de.ibm.com::EQVwpM2wMbUyDIkP:00000000000000000000000000000000000063cn
X-Hashcash: 1:20:150120:vgoyal@redhat.com::Dk3lfQ7DKt7l0WsI:000000000000000000000000000000000000000000006Nwk
X-Hashcash: 1:20:150120:vapier@gentoo.org::BM0wwNH2ZQcC4MwB:00000000000000000000000000000000000000000000BIzx
X-Hashcash: 1:20:150120:josh@joshtriplett.org::GtkfUM54Aw342ABy:0000000000000000000000000000000000000000EMMV
X-Hashcash: 1:20:150120:famz@redhat.com::V/L4EBuZBAWRJ4Ex:00DAtS
Date: Tue, 20 Jan 2015 11:37:22 +0100
In-Reply-To: <1421747878-30744-1-git-send-email-famz@redhat.com> (Fam Zheng's
	message of "Tue, 20 Jan 2015 17:57:52 +0800")
Message-ID: <874mrl3fh9.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20 2015, Fam Zheng <famz@redhat.com> wrote:

> DESCRIPTION
>
>        The epoll_mod_wait() system call can be seen as an enhanced combination
>        of several epoll_ctl(2) calls, which are followed by an epoll_pwait(2)
>        call. It is superior in two cases:
>        
>        1) When epoll_ctl(2) are followed by epoll_wait(2), using epoll_mod_wait
>        will save context switches between user mode and kernel mode;
>        
>        2) When you need higher precision than microsecond for wait timeout.

You probably want to say millisecond.

>            struct epoll_mod_cmd {
[...]
>            };


>            struct epoll_wait_spec {
[...]
>            } EPOLL_PACKED;

Either both or none of these should mention that EPOLL_PACKED is in fact
part of the actual definition. The changelog for 3/6 sorta mentions
that it's not really needed for epoll_mod_cmd. Why is it necessary for
either struct?

> RETURN VALUE
>
>        When successful, epoll_mod_wait() returns the number of file
>        descriptors ready for the requested I/O, or zero if no file descriptor
>        became ready during the requested timeout milliseconds.

And here, it doesn't make sense to mention a unit, since the new timeout
is given using struct timespec (this was the whole point, right?).

Rasmus
