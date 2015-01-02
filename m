Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbbABFLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 00:11:51 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49270 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbbABFLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 00:11:45 -0500
Date: Fri, 2 Jan 2015 06:11:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Kees Cook <keescook@chromium.org>
Cc: Richard Weinberger <richard@nod.at>, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Aaron Tomlin <atomlin@redhat.com>,
        DaeSeok Youn <daeseok.youn@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, vdavydov@parallels.com,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [PATCH] [RFC] Deter exploit bruteforcing
Message-ID: <20150102051142.GF4873@amd>
References: <1419457167-15042-1-git-send-email-richard@nod.at>
 <CAGXu5jKxzyjzoY_khgZu7TbxMhfG3jiXGObiaiUhx6g5-k9c6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKxzyjzoY_khgZu7TbxMhfG3jiXGObiaiUhx6g5-k9c6Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-12-30 10:40:15, Kees Cook wrote:
> On Wed, Dec 24, 2014 at 1:39 PM, Richard Weinberger <richard@nod.at> wrote:
> > While exploring the offset2lib attack I remembered that
> > grsecurity has an interesting feature to make such attacks
> > much harder. Exploits can brute stack canaries often very easily
> > if the target is a forking server like sshd or Apache httpd.
> > The problem is that after fork() the child has by definition
> > exactly the same memory as the parent and therefore also the same
> > stack canaries.
> > The attacker can guess the stack canaries byte by byte.
> > After 256 times 7 forks() a good exploit can find the correct
> > canary value.
> >
> > The basic idea behind this patch is to delay fork() if a child died
> > due to a fatal error.
> > Currently it delays fork() by 30 seconds if the parent tries to fork()
> > within 60 seconds after a child died due to a fatal error.
> >
> > I'm sure you'll hate this patch but I want to find out how much you hate it
> > and whether there is a little chance to get it mainline in a modified form.
> > Later I'd make it depend on a new Kconfig option and off by default
> > and the timing constants changeable via sysctl.

Does this break trinity, crashme, and similar programs?

Can you detect it died due to the stack canary? Then, the patch might
be actually acceptable.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
