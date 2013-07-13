Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab3GMHMu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 03:12:50 -0400
Received: from 1wt.eu ([62.212.114.60]:34578 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab3GMHMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 03:12:48 -0400
Date: Sat, 13 Jul 2013 09:12:39 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130713071239.GJ32054@1wt.eu>
References: <20130711222935.GA11340@redhat.com> <20130711224455.GA17222@kroah.com> <20130712141530.GA3629@roeck-us.net> <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com> <20130712173150.GA5534@roeck-us.net> <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com> <20130712195051.GB32054@1wt.eu> <20130713062223.GA15155@kroah.com> <20130713063607.GI32054@1wt.eu> <20130713064801.GA1305@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130713064801.GA1305@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 11:48:01PM -0700, Greg Kroah-Hartman wrote:
> > > And if something "fixes" an issue, then I want it in stable, just like
> > > Linus wants that in his tree.
> > 
> > It's the difference between "this is a fix" and "please backport this
> > fix into stable". As we aid in this thread, cc:stable is a bit too much
> > automatic and sometimes not appropriate (not important enough fixes).
> 
> No, I've never said that.
> 
> I _want_ fixes in stable trees, as they are being done to, obviously,
> fix problems.  So does Linus, why wouldn't a fix for something that is
> an issue for someone _not_ go into his tree after -rc4?
> 
> Ok, for some issues, they need some time to "bake" I can understand, but
> that's the exception not the rule at all.

I do think that most of the fixes that are sent to stable should bake a
little bit more, especially the ones that are not considered critical
(and that according to Linus should not be in stable). After all that's
what Davem does and there are probably less reverts in the stable net
tree than in others.

> If a distro would pick a patch up to solve a problem for a user, and
> that patch is in Linus's tree, there's almost no reason that shouldn't
> also be in the stable trees.

It is *my* conception of the stable branch, but I think that many people
have different expectations about what should be merged or not. For example
in old LTS branches, I used to merge what was relevant for servers only,
because I saw no reason why an old kernel would be used on a laptop (eg:
2.4). So I always skipped wifi, alsa, drm, etc... With 2.6.32, the Debian
kernel guys provided me with a lot of fixes in these areas, explaining
that these fixes addressed issues that their users were facing, and they
were perfectly right. It's just that I didn't expect this at all.

> My issue is that people are trying to get me to take stuff that is _not_
> fixes (i.e. build errors that are impossible to hit, or \n additions to
> debugging kernel messages, or pseudo-optimizations of functions).

But you see, maybe the '\n' additions are important to a specific development
team who relies on this all the day for their work. Importance is a relative
thing by nature. But I get your point anyway. Such low general importances
fixes could be marked "fix" without being marked "cc:stable" so that users
can later explicitly ask for their inclusion if they're concerned. That is
the way we know the problem affects some users. A few tens of the fixes that
went into 2.6.32.61 were requested by users, and I would never have have
picked them on my own if they hadn't asked.

> The other larger issue is that people somehow are not willing to send
> their valid fixes to Linus after -rc4, and they flood in during the -rc1
> merge and people expect me to backport them all into .1 because they are
> lazy.

I'm 100% sure this is true. Some fixes are probably written against a -next
tree, and adding a tag means "it will automatically be backported, no need
for a separate branch for this".

> Again, specific examples are the 7 powerpc patches that are over a month
> old that were marked for the stable tree, yet didn't hit Linus's tree
> until now.  I can dig up more examples if wanted, just look at the flood
> that comes in for -rc1.
> 
> I _should_ be seeing more patches marked for stable showing up after
> -rc3 then for -rc1.  As it is, I think there's something wrong with
> maintainers relying on me to do their work for them too much, and it's
> finally pushed me to start complaining and pushing back.

I'm sure this is true. But at the same time I also think that there is
a difference between what *you* expect in -stable and what Linus expects
there. Linus says that something not suitable for past -rc4 has no place
in -stable. You want most fixes that a distro would pick. But many of the
fixes a distro would pick are probably not important enough to be picked
past -rc4 and risk regressions. So these fixes are exposed to the world
in -rc1 for the first time in their life, and unfortunately are merged
at the same time.

The problem is to find a way to mark a fix as a candidate for stable but
with a reserve for some observation period. Maybe just some indication
that the fix should not be backported before the version it's merged into
is released ? That could make sense after all : many fixes that went into
3.11-rc1 were not important enough to go into 3.10, so they can wait for
3.11 to be released before being backported. But that requires an extra
queue.

Willy

