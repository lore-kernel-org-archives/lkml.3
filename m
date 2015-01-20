Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbbATKyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:54:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630AbbATKyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:54:41 -0500
Date: Tue, 20 Jan 2015 18:53:38 +0800
From: Fam Zheng <famz@redhat.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
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
Message-ID: <20150120105338.GA4040@ad.nay.redhat.com>
References: <1421747878-30744-1-git-send-email-famz@redhat.com>
 <874mrl3fh9.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874mrl3fh9.fsf@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01/20 11:37, Rasmus Villemoes wrote:
> On Tue, Jan 20 2015, Fam Zheng <famz@redhat.com> wrote:
> 
> > DESCRIPTION
> >
> >        The epoll_mod_wait() system call can be seen as an enhanced combination
> >        of several epoll_ctl(2) calls, which are followed by an epoll_pwait(2)
> >        call. It is superior in two cases:
> >        
> >        1) When epoll_ctl(2) are followed by epoll_wait(2), using epoll_mod_wait
> >        will save context switches between user mode and kernel mode;
> >        
> >        2) When you need higher precision than microsecond for wait timeout.
> 
> You probably want to say millisecond.

Yes, you see that I just can't make this right. :)

> 
> >            struct epoll_mod_cmd {
> [...]
> >            };
> 
> 
> >            struct epoll_wait_spec {
> [...]
> >            } EPOLL_PACKED;
> 
> Either both or none of these should mention that EPOLL_PACKED is in fact
> part of the actual definition. The changelog for 3/6 sorta mentions
> that it's not really needed for epoll_mod_cmd. Why is it necessary for
> either struct?

Yeah. it's probably not really necessary.

> 
> > RETURN VALUE
> >
> >        When successful, epoll_mod_wait() returns the number of file
> >        descriptors ready for the requested I/O, or zero if no file descriptor
> >        became ready during the requested timeout milliseconds.
> 
> And here, it doesn't make sense to mention a unit, since the new timeout
> is given using struct timespec (this was the whole point, right?).

Right!

Thanks,
Fam
