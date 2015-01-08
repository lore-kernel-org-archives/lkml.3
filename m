Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbbAHLsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 06:48:50 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:51456 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbbAHLss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 06:48:48 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <54AE65BB.1020707@redhat.com>
References: <1420708563-21743-1-git-send-email-famz@redhat.com>
 <1420708563-21743-3-git-send-email-famz@redhat.com> <54AE65BB.1020707@redhat.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 8 Jan 2015 12:48:27 +0100
Message-ID: <CAKgNAkiKz1pdt_uYpFDsCNLPr6UBJHZs72o3iAh57+7uG1uksQ@mail.gmail.com>
Subject: Re: [RESEND PATCH 2/3] epoll: Add implementation for epoll_pwait1
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Fam Zheng <famz@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Juri Lelli <juri.lelli@gmail.com>,
        Zach Brown <zab@zabbo.net>, David Drysdale <drysdale@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Dario Faggioli <raistlin@linux.it>, "Theodore Ts'o" <tytso@mit.edu>,
        Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Oleg Nesterov <oleg@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Fabian Frederick <fabf@skynet.be>,
        Josh Triplett <josh@joshtriplett.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 January 2015 at 12:10, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>
> On 08/01/2015 10:16, Fam Zheng wrote:
>> Unlike ppoll(2), which accepts a timespec argument "timeout_ts" to
>> specify the timeout, epoll_wait(2) and epoll_pwait(2) expect a
>> microsecond timeout in int type.
>>
>> This is an obstacle for applications in switching from ppoll to epoll,
>> if they want nanosecond resolution in their event loops.
>>
>> Therefore, adding this variation of epoll wait interface, giving user an
>> option with *both* advantages, is a reasonable move: there could be
>> constantly scalable performance polling many fds, while having a
>> nanosecond timeout precision (assuming it has properly set up timer
>> slack with prctl(2)).
>>
>> Signed-off-by: Fam Zheng <famz@redhat.com>
>> ---
>>  fs/eventpoll.c           | 24 ++++++++++++++++++++++++
>>  include/linux/syscalls.h |  4 ++++
>>  kernel/sys_ni.c          |  3 +++
>>  3 files changed, 31 insertions(+)
>
> As mentioned by Miklos in the non-resent version, please add a flags
> argument.  Invalid flags should return -EINVAL.
>
> In fact, we could already use the flags argument to specify an absolute
> timeout, which is a nice thing to have for QEMU too.

Nice! It looks like we found this iteration of "failure to include a
flags argument is a mistake" already!

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
