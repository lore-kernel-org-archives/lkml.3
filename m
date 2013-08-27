Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3H0PMC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:12:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab3H0PMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:12:00 -0400
Date: Tue, 27 Aug 2013 17:05:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] proc: make proc_fd_permission() thread-friendly
Message-ID: <20130827150535.GD19425@redhat.com>
References: <20130825065039.GB9299@1wt.eu> <CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com> <20130825194844.GA16717@redhat.com> <CA+55aFzbY3zYD1i5x02Z-6K3nHKzJj6227ZBYRLqij9y0eXRqQ@mail.gmail.com> <20130826153301.GA15890@redhat.com> <20130826163704.GA21763@redhat.com> <20130826175441.GA28856@redhat.com> <CA+55aFzCghYYF1_dcvBY9XZ82TU9b=hhgFqkGoWpaZuKJ7R6_A@mail.gmail.com> <CA+55aFwAw=AZNqmDNip_P6WiY4zGRNWks-kLwN7ZgJ8JJsAx-A@mail.gmail.com> <20130826202028.GB24065@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826202028.GB24065@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, Willy Tarreau wrote:
>
> On Mon, Aug 26, 2013 at 12:35:26PM -0700, Linus Torvalds wrote:
> (...)
> > Yes, it would be semantically different, but it would mean that
> > "/proc/self/fd/" would actually make sense in a way that it currently
> > does *not* - which would seem fairly important, since the primary use
> > for it tends to be /dev/stdin.
>
> I remember another user, don't know if that has changed. UPX used to build
> self-extract binaries that opened /proc/self/fd/3.

But /proc/<tgid>/fd and /proc/<tid>/fd should be the same. Unless it plays
with unshare() or clone(CLONE_THREAD /* no CLONE_FILES */).

Unlike, but:

> because it's typically a usage that
> could be discovered to be broken months after the change!

Oh yes, I agree. This change is trivial but nasty, god knows what people
actually do with /proc/self.

Oleg.

