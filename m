Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbbAWGV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:21:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbbAWGV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:21:57 -0500
Date: Fri, 23 Jan 2015 14:20:50 +0800
From: Fam Zheng <famz@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Miklos Szeredi <mszeredi@suse.cz>,
        David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH RFC 5/6] epoll: Add implementation for epoll_mod_wait
Message-ID: <20150123062050.GA7071@ad.nay.redhat.com>
References: <1421747878-30744-1-git-send-email-famz@redhat.com>
 <1421747878-30744-6-git-send-email-famz@redhat.com>
 <54BE4F1D.7090807@gmail.com>
 <20150121045903.GA2858@fam-t430.nay.redhat.com>
 <54BF5ACE.6030206@gmail.com>
 <20150121085827.GB23024@ad.nay.redhat.com>
 <54BF814F.7090703@redhat.com>
 <20150121111404.GA3804@ad.nay.redhat.com>
 <54BF9294.3070902@redhat.com>
 <CALCETrWwuJpFK+38mBxxTQCu7Oig22Nr+mAuO++Y+0CdAhfzkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWwuJpFK+38mBxxTQCu7Oig22Nr+mAuO++Y+0CdAhfzkw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01/22 13:12, Andy Lutomirski wrote:
> On Wed, Jan 21, 2015 at 3:50 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> >
> > On 21/01/2015 12:14, Fam Zheng wrote:
> >> > My take for simplicity will be leaving epoll_ctl as-is, and my take for
> >> > performance will be epoll_pwait1. And I don't really like putting my time on
> >> > epoll_ctl_batch, thinking it as a ambivalent compromise in between.
> >>
> >> > I agree with Michael actually.  The big change is going from O(n)
> >> > epoll_ctl calls to O(1), and epoll_ctl_batch achieves that just fine.
> >> > Changing 2 syscalls to 1 is the icing on the cake, but we're talking of
> >> > a fraction of a microsecond.
> >>
> >> Maybe I'm missing something, but in common cases, the set of fds for epoll_wait
> >> doesn't change that radically from one iteration to another, does it?
> >
> > That depends on the application.
> 
> In my application, the set of fds almost never changes, but the set of
> events I want changes all the time.  The main thing that changes is
> whether I care about EPOLLOUT.  If I'm ready to send something, then I
> want EPOLLOUT.  If I'm not ready, then I don't want EPOLLOUT.
> 

OK, I'll split it to epoll_ctl_batch and epoll_pwait1 as Micheal suggested in
v2.

Fam
