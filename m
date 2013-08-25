Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab3HYTzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 15:55:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756614Ab3HYTzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 15:55:06 -0400
Date: Sun, 25 Aug 2013 21:48:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: /proc/pid/fd && anon_inode_fops
Message-ID: <20130825194844.GA16717@redhat.com>
References: <20130822185317.GI31117@1wt.eu> <CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com> <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com> <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com> <20130822201530.GL31117@1wt.eu> <20130824182939.GA23630@redhat.com> <20130824212432.GA9299@1wt.eu> <20130825052317.GZ27005@ZenIV.linux.org.uk> <20130825065039.GB9299@1wt.eu> <CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cough. I am going off-topic again, but I can't resist...

On 08/25, Linus Torvalds wrote:
>
> Look at the code that creates the fd stat information, for example.
> It's in tid_fd_revalidate(), and it really doesn't make much sense to
> use the task credentials for it.

Or pid_revalidate(), but my concern is task_dumpable() logic.

pid_revalidate() does inode->i_*id = GLOBAL_ROOT_*ID if task_dumpable()
fails, but it can fail simply because ->mm = NULL.

This means that almost everything in /proc/zombie-pid/ becomes root.
Doesn't really hurt, but for what? Looks a bit strange imho.

Oleg.

