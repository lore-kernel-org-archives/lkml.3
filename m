Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab3H0Pvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:51:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab3H0Pvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:51:36 -0400
Date: Tue, 27 Aug 2013 17:45:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
        Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] proc: make proc_fd_permission() thread-friendly
Message-ID: <20130827154513.GA27943@redhat.com>
References: <20130825065039.GB9299@1wt.eu> <CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com> <20130825194844.GA16717@redhat.com> <CA+55aFzbY3zYD1i5x02Z-6K3nHKzJj6227ZBYRLqij9y0eXRqQ@mail.gmail.com> <20130826153301.GA15890@redhat.com> <20130826163704.GA21763@redhat.com> <20130826175441.GA28856@redhat.com> <CA+55aFzCghYYF1_dcvBY9XZ82TU9b=hhgFqkGoWpaZuKJ7R6_A@mail.gmail.com> <CA+55aFwAw=AZNqmDNip_P6WiY4zGRNWks-kLwN7ZgJ8JJsAx-A@mail.gmail.com> <CALCETrXP-mYBPRon=0NzexW1FK1Qxz2+Bwv7-WeHBQpvW7ywRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXP-mYBPRon=0NzexW1FK1Qxz2+Bwv7-WeHBQpvW7ywRg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, Andy Lutomirski wrote:
>
> On Aug 26, 2013 12:35 PM, "Linus Torvalds" <torvalds@linux-foundation.org>
> wrote:
> >
> > Yes, it would be semantically different, but it would mean that
> > "/proc/self/fd/" would actually make sense in a way that it currently
> > does *not* - which would seem fairly important, since the primary use
> > for it tends to be /dev/stdin.
> >
> > And the other semantic differences might be much harder to notice.
> > Worth testing?
>
> The "children" subdirectory will be different.  But it's already screwed up.

No, it lives in tid_base_stuff, it should be only visible in
/proc/*/task/tid/ dir.

(and perhaps it also makes sense to remove mem/exe-like things from
 tid_base_stuff...)

Anyway I agree, this change is risky.

Oleg.

