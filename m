Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab3HZTf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 15:35:29 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:59550 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab3HZTf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 15:35:27 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzCghYYF1_dcvBY9XZ82TU9b=hhgFqkGoWpaZuKJ7R6_A@mail.gmail.com>
References: <20130822201530.GL31117@1wt.eu>
	<20130824182939.GA23630@redhat.com>
	<20130824212432.GA9299@1wt.eu>
	<20130825052317.GZ27005@ZenIV.linux.org.uk>
	<20130825065039.GB9299@1wt.eu>
	<CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com>
	<20130825194844.GA16717@redhat.com>
	<CA+55aFzbY3zYD1i5x02Z-6K3nHKzJj6227ZBYRLqij9y0eXRqQ@mail.gmail.com>
	<20130826153301.GA15890@redhat.com>
	<20130826163704.GA21763@redhat.com>
	<20130826175441.GA28856@redhat.com>
	<CA+55aFzCghYYF1_dcvBY9XZ82TU9b=hhgFqkGoWpaZuKJ7R6_A@mail.gmail.com>
Date: Mon, 26 Aug 2013 12:35:26 -0700
X-Google-Sender-Auth: 0tYriPBQgiiWHoalIY8yzD8sWwA
Message-ID: <CA+55aFwAw=AZNqmDNip_P6WiY4zGRNWks-kLwN7ZgJ8JJsAx-A@mail.gmail.com>
Subject: Re: [PATCH] proc: make proc_fd_permission() thread-friendly
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 11:09 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Patch looks ok to me, but since this has never worked and nobody has
> actually complained, I can't really convince myself that this is
> critical.

Actually, let's back-track..

Did you try the other approach? Make /proc/self point to the thread
instead of the task?

The thread-group leader seems to have these extra files:

 - autogroup, coredump_filter, mountstats, net, task

but quite frankly, at least "net" and "task" look like they should
exist there - with "task" pointing back to the actual task (it would
make more sense for "/proc/<pid>/task" itself to be named "threads",
but whatever).

Yes, it would be semantically different, but it would mean that
"/proc/self/fd/" would actually make sense in a way that it currently
does *not* - which would seem fairly important, since the primary use
for it tends to be /dev/stdin.

And the other semantic differences might be much harder to notice.
Worth testing?

                 Linus
