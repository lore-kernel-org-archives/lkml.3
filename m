Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab3ICP6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 11:58:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36728 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab3ICP6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:58:02 -0400
Date: Tue, 3 Sep 2013 17:58:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Willy Tarreau <w@1wt.eu>,
        Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: /proc/pid/fd && anon_inode_fops
Message-ID: <20130903155759.GB14734@amd.pavel.ucw.cz>
References: <CA+55aFzXNU-eJ7KeZyv5YYKKtm8iorG-o3QtD7NXx0GTzuH+Bw@mail.gmail.com>
 <20130822185317.GI31117@1wt.eu>
 <CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com>
 <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
 <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
 <20130822201530.GL31117@1wt.eu>
 <20130824182939.GA23630@redhat.com>
 <20130824212432.GA9299@1wt.eu>
 <20130825052317.GZ27005@ZenIV.linux.org.uk>
 <CA+55aFy_W_rEeCyrTWMx55WNDh4HaOs5O-krQMqLUjOc=MxA3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy_W_rEeCyrTWMx55WNDh4HaOs5O-krQMqLUjOc=MxA3A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > We are really stuck with the current semantics here - switching to
> > *BSD one would not only mean serious surgery on descriptor handling
> > (it's one of the wartier areas in *BSD VFS, in large part because
> > of magic-open-really-a-dup kludges they have to do), it would change
> > a long-standing userland API that had been there for nearly 20 years
> > _and_ one that tends to be used in corner cases of hell knows how many
> > scripts.
> 
> Actually, I'm pretty sure we did have the "dup" semantics at one point
> (long ago), and they were really nice (because you could use them to
> see where in the stream the fd was etc). It just fit so horribly badly
> into the VFS semantics that it got changed into the current "new file
> descriptor" one. Afaik, nothing broke.

Hmm, are you going to break my exploit?

http://www.exploit-db.com/exploits/10038/

I'd like that, because I don't think /proc should allow people to
bypass directory permissions.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
