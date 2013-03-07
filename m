Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab3CGXDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 18:03:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab3CGXDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 18:03:19 -0500
Date: Thu, 7 Mar 2013 18:03:02 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: BUG_ON(nd->inode->i_op->follow_link);
Message-ID: <20130307230302.GA4495@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20130307021645.GA10173@redhat.com>
 <20130307153052.GA18246@redhat.com>
 <CA+55aFyVZeDswi=M65ULQkGCvJq5vsASLqGCtufH3TcS--MC1Q@mail.gmail.com>
 <20130307193501.GA2802@redhat.com>
 <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
 <20130307221800.GA572@redhat.com>
 <CA+55aFwObv7--izbae5YdXX3AhoHfV0YwbSLQoonTf-=e4PzqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwObv7--izbae5YdXX3AhoHfV0YwbSLQoonTf-=e4PzqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 02:50:55PM -0800, Linus Torvalds wrote:

 > Yes, I can reproduce this, and I know what's going on. I don't have a
 > patch, though, and I think it's in Al's court on what we should do.
 > Al?
 > 
 > Anyway, so the "old=fd" thing implies that it's one of the symlinks in
 > /proc/xyz/fd/, so that's something. It could have been the
 > cwd/exe/mmap ones. But that was kind of the expectation to begin with.
 > 
 > The "new=1:9" is the path that the file descriptor contained, and
 > since you're playing games with /proc, /sys and /dev, *and* since you
 > hit the "it shouldn't be a symlink" test, I'm *guessing* that it might
 > be something like
 > 
 >     /sys/dev/char/1:9

Strange, I told it to *only* use /proc on that run, so it shouldn't have sucked
in anything from /dev unless something in /proc symlinks there and nftw()
ended up chasing it.

 > which is a symlink to ../../devices/virtual/mem/urandom/.
 > 
 > And here is how you reproduce this:

But this at least is one step towards restoring my belief that I'm not
going crazy here.

 > Al, I think the BUG_ON() is simply bogus. Should we just remove it? Or
 > is there some conceptual reason why we can't handle a symlink there?

For the time being, I'll remove that just so I can stop seeing it,
as it seems there's plenty of others to be chasing and you've got
a handle on this one.

	Dave

