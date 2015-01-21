Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbbAULwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:52:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbbAULv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:51:57 -0500
Message-ID: <54BF9294.3070902@redhat.com>
Date: Wed, 21 Jan 2015 12:50:44 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Fam Zheng <famz@redhat.com>
CC: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
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
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH RFC 5/6] epoll: Add implementation for epoll_mod_wait
References: <1421747878-30744-1-git-send-email-famz@redhat.com> <1421747878-30744-6-git-send-email-famz@redhat.com> <54BE4F1D.7090807@gmail.com> <20150121045903.GA2858@fam-t430.nay.redhat.com> <54BF5ACE.6030206@gmail.com> <20150121085827.GB23024@ad.nay.redhat.com> <54BF814F.7090703@redhat.com> <20150121111404.GA3804@ad.nay.redhat.com>
In-Reply-To: <20150121111404.GA3804@ad.nay.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/01/2015 12:14, Fam Zheng wrote:
> > My take for simplicity will be leaving epoll_ctl as-is, and my take for
> > performance will be epoll_pwait1. And I don't really like putting my time on
> > epoll_ctl_batch, thinking it as a ambivalent compromise in between.
> 
> > I agree with Michael actually.  The big change is going from O(n)
> > epoll_ctl calls to O(1), and epoll_ctl_batch achieves that just fine.
> > Changing 2 syscalls to 1 is the icing on the cake, but we're talking of
> > a fraction of a microsecond.
> 
> Maybe I'm missing something, but in common cases, the set of fds for epoll_wait
> doesn't change that radically from one iteration to another, does it?

That depends on the application.

Paolo
