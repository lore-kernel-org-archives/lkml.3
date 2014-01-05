Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaAEWXn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 17:23:43 -0500
Received: from asav12.altibox.net ([81.167.36.146]:53614 "EHLO
	asav12.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaAEWXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 17:23:41 -0500
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jan 2014 17:23:41 EST
Date: Sun, 5 Jan 2014 23:13:04 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        James Hogan <james.hogan@imgtec.com>, Michal Marek <mmarek@suse.cz>,
        Paul Mundt <lethal@linux-sh.org>, Shawn Guo <shawn.guo@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [patch core/stackprotector] stackprotector: Fix build when
 compiler lacks support
Message-ID: <20140105221304.GA11197@ravnborg.org>
References: <1387481759-14535-3-git-send-email-keescook@chromium.org>
 <tip-8779657d29c0ebcc0c94ede4df2f497baf1b563f@git.kernel.org>
 <alpine.DEB.2.02.1312301331520.10482@chino.kir.corp.google.com>
 <CAGXu5jJxkD7rS0gFAS3mAhwxP05UMW8KNW00C_e2v=Keqj7k3Q@mail.gmail.com>
 <CA+55aFy65HwuqjsZhhTDBy1GYyxig8De=3XZxn8ixnGN7xWMFQ@mail.gmail.com>
 <20140101114244.GB3372@free.fr>
 <CA+55aFzS2bTXSDabNhsZXhpVWP9toqtubB3jrNVWF-FaQrmz-w@mail.gmail.com>
 <20140101222808.GB19648@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140101222808.GB19648@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

> > 
> >   config CC_SUPPORTS_STACKPROTECTOR_STRONG
> >       bool
> >       option exec="$CC -fstack-protector-strong -c empty.c"
> > 
> > or something like that. No?
> 
> This is an implementation detail, but the original patch expected the
> result to be 'y' or 'n' (or empty=='n') on stdout. That way, it could
> also be used to fill-in config options that are strings, or ints. Hence
> the use of a script.
> 
> But H. Peter suggested it should only return a boolean, which seems
> entirely reasonable, given the purpose of this. In this case, using 'y'
> or 'n' from stdout, or 0 or !0 from the exit code are equally easy.
> 
> Also, using a single shell script allows to fix/enhance all of those
> calls in a single place, and avoids duplicating all the check logic in
> every tests (eg. who is going to create empty.c in your example? Clean
> up the output file?). And since kconfig is run from the top-level of the
> Linux source tree (even for out-of-tree builds), we can safely use a
> path relative to that to call our script(s).
> 
> I'll wait a bit until the end of the holiday season before I poke Sam
> again on this.

The thinking behind the exec option was that it should return a string,
and then the content of the string were parsed depending on the type used in
the kconfig language.
So for a bool "y" and "n" would be recognized.
For tristate in adddition "m" would be recognized.
For int we should be able to parse numbers.
And string would be string.

An if an exec'ed command gave e return code != 0 then this should result in a warning,
so user is told that the attempt to execute /bin/some_thing_random failed.
Otherwise we would end in situations were this would be difficult to debug.

I have no time to actually implement the above proposal - sorry!
But things are busy at my day-time job etc.
So I hope someone can step in and help here.

PS. I have suffered from a faulty linux box + change of mail provider.
    And in the end I deleted all mails from the last three months.
    This was much quicker than to actually read them :-)

	Sam
