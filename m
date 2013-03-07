Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab3CGXzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 18:55:48 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:60911 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816Ab3CGXzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 18:55:47 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwObv7--izbae5YdXX3AhoHfV0YwbSLQoonTf-=e4PzqQ@mail.gmail.com>
References: <20130307021645.GA10173@redhat.com>
	<20130307153052.GA18246@redhat.com>
	<CA+55aFyVZeDswi=M65ULQkGCvJq5vsASLqGCtufH3TcS--MC1Q@mail.gmail.com>
	<20130307193501.GA2802@redhat.com>
	<CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
	<20130307221800.GA572@redhat.com>
	<CA+55aFwObv7--izbae5YdXX3AhoHfV0YwbSLQoonTf-=e4PzqQ@mail.gmail.com>
Date: Thu, 7 Mar 2013 15:55:46 -0800
X-Google-Sender-Auth: KoFOynKYFGybvfEfD_rnWrZ2dzo
Message-ID: <CA+55aFyJP2qtXAX4AbnXFQF4dp9WRgLWFNX6Y_A5Ys=gt1tBKg@mail.gmail.com>
Subject: Re: BUG_ON(nd->inode->i_op->follow_link);
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 2:50 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Al, I think the BUG_ON() is simply bogus. Should we just remove it? Or
> is there some conceptual reason why we can't handle a symlink there?

Hmm. Removing the BUG_ON() makes things work. Sure, you can get odd
files that are symlinks, but that's kind of what you ask for when you
do that whole O_NOFOLLOW thing, so the fact that you can then get them
through opening the /proc/<pid>/fd/<fd> file would seem to be roughly
the right thing regardless.

So I think I'll queue up that removal, although I'd still be happier
with input from Al.

               Linus
