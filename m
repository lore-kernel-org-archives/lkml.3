Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbbAUKf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:35:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbbAUKfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:35:47 -0500
Message-ID: <54BF80BE.3070707@redhat.com>
Date: Wed, 21 Jan 2015 11:34:38 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Fam Zheng <famz@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
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
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH RFC 5/6] epoll: Add implementation for epoll_mod_wait
References: <1421747878-30744-1-git-send-email-famz@redhat.com> <1421747878-30744-6-git-send-email-famz@redhat.com> <54BE4F1D.7090807@gmail.com> <20150121045903.GA2858@fam-t430.nay.redhat.com> <54BF5ACE.6030206@gmail.com>
In-Reply-To: <54BF5ACE.6030206@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/01/2015 08:52, Michael Kerrisk (man-pages) wrote:
>> > The problem is that there is no room for flags field in epoll_pwait1, which is
>> > asked for, in previous discussion thread [1].
> Ahh yes, I certainly should not have forgotten that. But that's easily solved.
> Do as for pselect6():
> 
> strcut sigargs {
>     const sigset_t *ss;
>     size_t          ss_len; /* Size (in bytes) of object pointed
>                                to by 'ss' */
> }
> 
> epoll_pwait1(int epfd, struct epoll_event *events, int maxevents, 
>              struct timespec *timeout, int clock_id, int flags,
>              int timeout,
>              const struct sigargs *sargs);
> 

Alternatively, place the clock_id in the lower 16 bits of flags.
MAX_CLOCKS is 16 right now, so there's room.

Paolo
