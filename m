Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3HZSwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 14:52:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab3HZSwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 14:52:54 -0400
Date: Mon, 26 Aug 2013 20:46:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] proc: make proc_fd_permission() thread-friendly
Message-ID: <20130826184631.GA30917@redhat.com>
References: <20130824212432.GA9299@1wt.eu> <20130825052317.GZ27005@ZenIV.linux.org.uk> <20130825065039.GB9299@1wt.eu> <CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com> <20130825194844.GA16717@redhat.com> <CA+55aFzbY3zYD1i5x02Z-6K3nHKzJj6227ZBYRLqij9y0eXRqQ@mail.gmail.com> <20130826153301.GA15890@redhat.com> <20130826163704.GA21763@redhat.com> <20130826175441.GA28856@redhat.com> <87ioyspaju.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ioyspaju.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > proc_fd_permission() says "process can still access /proc/self/fd
> > after it has executed a setuid()", but the "task_pid() = proc_pid()
> > check only helps if the task is group leader, /proc/self points to
> > /proc/leader-pid.
> >
> > Change this check to use task_tgid() so that the whole process can
> > access /proc/self/fd.
>
> There is at least a semantic goofiness here.
>
> There is /proc/<tgid>/fd and /proc/<tgid>/task/<pid>/fd, and the same
> permission check is used by both.

Yes, and we have /proc/<tid>/ which includes fd as well.

> We might just want to have a /proc/thread symlink as well so people
> don't have this issue.

Yes! I agree.

In particular, from the changelog:

	Note: CLONE_THREAD doesn't require CLONE_FILES so task->files can
	differ,

so /proc/self/fd doesn't necessarily mean current->files, this can confuse
the application.

And I also assume that you agree with this change ;)

Oleg.

