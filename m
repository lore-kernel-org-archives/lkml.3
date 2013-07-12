Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965254Ab3GLRuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:50:11 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:33435 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964906Ab3GLRuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:50:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130712173150.GA5534@roeck-us.net>
References: <20130711214830.611455274@linuxfoundation.org>
	<20130711222935.GA11340@redhat.com>
	<20130711224455.GA17222@kroah.com>
	<20130712141530.GA3629@roeck-us.net>
	<CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
	<20130712173150.GA5534@roeck-us.net>
Date: Fri, 12 Jul 2013 10:50:08 -0700
X-Google-Sender-Auth: MUQi29vlYWEVRKhUyYCPexrQOTY
Message-ID: <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 10:31 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>
> Stable rules say: "It must fix a real bug that bothers people (not a, "This
> could be a problem..." type thing). All the above fit that rule.

You cut out the important part:

 - It must fix a problem that causes a build error (but not for things
   marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
   security issue, or some "oh, that's not good" issue.  In short, something
   critical.

That list is not a "or" list, it's an "and" list - it needs to follow
*all* the rules. The exception is the "New device IDs and quirks are
also accepted", which maybe should be made more clearly separate.

> But are those patches critical ? Sure, people complained about getting alarms
> on the wrong attribute or not getting alarms when they expected to, but critical ?
> No, unless some application at some point starts to shut down the system because
> of a false alarm. So I guess the above should not go into -stable, then.

Right. And that's what the stable rules say. It's not enough to be a
"real bug". It needs to be critical. If it's something that has been
around forever, there needs to be a stronger argument than "I found a
bug" for marking it for stable.

> Problem is with "bothers people" vs. "critical".

There is no "vs".

The "real bug that bothers people" rule is not meant to be seen as a
separate rule from the next rule (already quoted above), it needs to
be *in*addition*to*.

For example, we have the "causes a build error" case - but that should
be seen in the "real bug that bothers people" light, and you should
not mark Kconfig fixes for stable unless they have actually caused
problems. Why? Because most Kconfig problems tend to be for
unrealistic situations like "Oh, if I turn off PCI or networking, this
driver no longer builds". Sure, that is a bug, and it's a bug that
causes build error, but it's not something that bothers real people,
because if you turn off networking or turn off PCI, you damn well had
better also turn off all the other crap you don't need.

Yes, there are always going to be gray areas. And Greg is obviously a
much nicer person than I am, so he's likely *always* going to be more
generous about those gray aras than I would be. And within reason, I
think that's perfectly fine - if there's a few patches that get marked
for stable because it's easier for people to sneak them in that way,
whatever. It becomes a problem only when it gets to be *too* common,
which is apparently what happened now.

So I'm not going to argue that your particular patches were the
problem here. I'm more arguing against your arguments than against the
patches themselves. I'm not looking for some hard black-and-white
rules that say "this is exactly how things have to work", because I
don't think such rules can exist. But I _do_ want people to see the
stable rules as fairly strict. And in particular, I really don't think
people should see "post-rc4" to be any different from "stable".

If anything, I think post-rc4 should be easier to get into, if only
because post-rc4 has the additional "hey, if it's new code that hasn't
seen a release yet, we can be much more aggressive about it". For
example, I think I'm *much* more open to reverting new commits
entirely in the late rc's than we should ever be for stable.

            Linus
