Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab3IAPty (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 11:49:54 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:45165 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab3IAPtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 11:49:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130901111008.GA28812@thunk.org>
References: <CA+55aFz7k5zUvJdZxpZgCgfx_-PT+f-9J50hnC1i3x=8_dXkBw@mail.gmail.com>
	<20130901085049.21748.qmail@science.horizon.com>
	<20130901111008.GA28812@thunk.org>
Date: Sun, 1 Sep 2013 08:49:48 -0700
X-Google-Sender-Auth: WOGJZgD6C_RmrXkZk7zMO9yG88U
Message-ID: <CA+55aFx5oAdGHGXd9P95-0UrKe9Tki_8Q8NoUtCVJtM-=he-Cg@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>, George Spelvin <linux@horizon.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Waiman Long <waiman.long@hp.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 1, 2013 at 4:10 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> Speaking of bool (and I'm not a fan of it either), is this warning
> just noise (which is bad enough since it masks real warnings), or is
> this going to cause serious problems?
>
>   CHECK   /usr/projects/linux/ext4/kernel/trace/trace.c
> /usr/projects/linux/ext4/kernel/trace/trace.c:559:6: warning: symbol 'free_snapshot' was not declared. Should it be static?
> /usr/projects/linux/ext4/kernel/trace/trace.c:1489:14: warning: expression using sizeof bool

It's just because sparse is being a bit odd. Internally, sparse thinks
that "bool" has a size of one bit. So it then the sizeof code has a
special case to make it one byte, and when that special case was
added, people added the warning too.

I suspect we sparse should just make the size of "bool" be 8 bits
internally, and we should drop the warning. As it is, sparse will
actually do odd and wrong things due to the "bool is one bit" if you
put "bool" types in structures or unions, I think.

Nobody used to care, because we used to not use that broken type in the kernel.

            Linus
