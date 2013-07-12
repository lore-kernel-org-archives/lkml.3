Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764Ab3GLTvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 15:51:05 -0400
Received: from 1wt.eu ([62.212.114.60]:34550 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757590Ab3GLTvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 15:51:01 -0400
Date: Fri, 12 Jul 2013 21:50:51 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130712195051.GB32054@1wt.eu>
References: <20130711214830.611455274@linuxfoundation.org> <20130711222935.GA11340@redhat.com> <20130711224455.GA17222@kroah.com> <20130712141530.GA3629@roeck-us.net> <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com> <20130712173150.GA5534@roeck-us.net> <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 10:50:08AM -0700, Linus Torvalds wrote:
> So I'm not going to argue that your particular patches were the
> problem here. I'm more arguing against your arguments than against the
> patches themselves. I'm not looking for some hard black-and-white
> rules that say "this is exactly how things have to work", because I
> don't think such rules can exist. But I _do_ want people to see the
> stable rules as fairly strict.

I think that maintainers are balanced between the wish to satisfy their
users and the risk of getting shouted at. Users expect stable versions
to be bug-free. Most people I talk with have a different understanding
of the development model than the one you present to contributors. They
think that the .0 release is a draft and that all bugs will be fixed in
-stable. I even know one person who uses -rc1 in production, claiming
that these ones are stable. So end users don't necessarily understand
the development model and ask what something they think is due : no
known bugs.

On the other hand, we've seen many regressions introduced as fixes
into -stable that had to be reverted afterwards, or sometimes
completed with a missing patch.

I think that maintainers use the Cc:stable as a status for commits
meaning "this is a bug fix". It's true that when you're digging into
the commits to try to qualify fixes from features, it's really hard,
and the new Cc:stable tag helps a lot.

So probably we should incite patch contributors to add a specific
tag such as "Fixes: 3.5 and later", so that non-important patches
do not need the Cc:stable anymore, but users who experience an issue
can easily spot them and ask for their inclusion.

I've already experienced the other way around, been hit by a missing
fix from 2.6.32.x that was not backported there probably because it
was considered minor (and it was for most environments), except that
it caused a complete web site to go down due to gro/gso issues with
LVS. It's typically the type of bug that is not reported by most
users, and that noone will consider critical, but once such a user
encounters it, it's far too late, the harm is already done. It's
too bad when both the bug and the fix are known and available, we
just need to *know* they exist.

While we can't ask Greg to collect all the bug fixes on the planet,
we should probably do something so that end users can more easily
spot what is relevant to their usage and from time to time ask for
these ones to be merged if that makes sense.

Willy

