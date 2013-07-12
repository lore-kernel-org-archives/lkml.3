Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965238Ab3GLRbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:31:51 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:47498 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813Ab3GLRbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:31:49 -0400
Date: Fri, 12 Jul 2013 10:31:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130712173150.GA5534@roeck-us.net>
References: <20130711214830.611455274@linuxfoundation.org>
 <20130711222935.GA11340@redhat.com>
 <20130711224455.GA17222@kroah.com>
 <20130712141530.GA3629@roeck-us.net>
 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 08:22:27AM -0700, Linus Torvalds wrote:
> On Fri, Jul 12, 2013 at 7:15 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> >> >
> >> > I get the impression as soon as we hit -rc1, some maintainers immediately
> >> > go into "OH SHIT, I CAN'T SEND PATCHES OR LINUS WILL SHOUT AT ME" mode.
> >>
> >> I agree.  But it seems that I need to now start shouting at them :(
> >
> > Just like others, I now have a cutoff-point for -stable patches. Depending on
> > the severity of a bug, it is somewhere between -rc4 and -rc6. After -rc6 I only
> > push regressions and crash fixes; the rest has to wait for the commit window.
> 
> So regressions, crash fixes (and security issues) is exactly what I
> want to get after -rc3 or so. And yes, I will start shouting at people
> if other things show up.
> 
> However, I think your comments clearly show the problem:
> 
> > So, yes, there are a couple of hwmon patches in your list.
> >
> > From a maintainer perspective, seems to me we are stuck between a rock and a
> > hard place. Yes, I would prefer to push all -stable material even late in the
> > -rc game, but that is not how things work nowadays anymore.
> 
> That's f*cking sad. You know *why* it's sad?
> 
> Go read the rules for stable patches. Really.
> 
41fa9a944 hwmon: (nct6775) Drop unsupported fan alarm attributes for NCT6775
b1d2bff6a hwmon: (nct6775) Fix temperature alarm attributes

Stable rules say: "It must fix a real bug that bothers people (not a, "This
could be a problem..." type thing). All the above fit that rule.

But are those patches critical ? Sure, people complained about getting alarms
on the wrong attribute or not getting alarms when they expected to, but critical ?
No, unless some application at some point starts to shut down the system because
of a false alarm. So I guess the above should not go into -stable, then.

> Because the rules for stable patches are the rules _I_ use for that
> late -rc stuff, and is pretty much exactly what you yourself described
> as "this is what I send Linus after -rc4".
> 
> Now, that should make you think about THE ABSOLUTE CRAP YOU MARK FOR -stable!
> 
> If it isn't important enough to send to me after -rc4, then it damn
> well isn't important enough to mark for stable either!
> 
> It really is that simple.
> 
> > This should really be discussed at the Kernel Summit. Overall, I don't really
> > care too much how to handle it. Just tell me. The outlook of "Either Linus
> > will shout at you or Greg will" doesn't sound like a good solution, though.
> 
> Listen to yourself. In fact, there is a damn good solution": don't
> mark crap for stable, and don't send crap to me after -rc4.
> 
> If it doesn't fit the stable rules, they should go in the next merge
> window. It really is that simple. You even (unwittingly) pretty much
> described the stable rules, but then you apparently didn't understand
> that those were the rules for -stable too.
> 
Problem is with "bothers people" vs. "critical". A lot of things bother people
which are not critical. I personally have to back-port patches from upstream
into my company's tree to fix bugs. Do those patches always fix critical bugs ?
No, but I still have to have them fixed. But I would still prefer to have those
patches applied to -stable, first to ensure broad test coverage but also to
prevent others to hit the same problems I had, and in the hope they do the same
favor to me at some point.

Overall, given your feedback, I think that stable-rules should be clarified.
"real bug ... bothers people" should replaced with a clear statement such as
"It must fix a critical bug", and the list of examples should follow (instead
of making the term "critical" a side note of the list of examples).

What you are really saying is that -stable shall not be used by anyone to
assume that "this is a kernel you can use in your distribution", but that
you _expect_ every distribution to run patched kernels and to spend a lot
of time tracking down and applying upstream patches. Like Greg pointed out
in one of his replies- you _want_ to put more burden on distribution maintainers.

Personally I am not sure if that really makes much sense - I for my part
would prefer to have the official stable rules follow the "must fix a real
bug that bothers people" rule rather than the "must fix a critical bug"
rule, and have stable kernels which need as few as possible additional
patches on top - all that for the simple reason to get as much test coverage
as possible on a common baseline. But that may be just me.

> Of course, I suspect I see why this happens. Greg doesn't shout as
> much as me, and he has been taking any random patches into -stable. So
> the end result is that people think it's easier to mark things for
> -stable than it is to show that it actualy *is* stable, and they are
> trying to use -stable as a way to get any random late fixes in.
> 
> That is not how stable should work. When stable started, it had some
> rather clear rules. It's not for "fixes". It was meant to be solely
> for big issues.
> 
Please keep in mind that not all of us were there at that time.

> The thing you just described that you put a stable tag on is *EXACTLY*
> the things that should not be marked for stable. For *EXACTLY* the
> same reason that you realized you shouldn't push it to me after -rc4.
> 
> Do you really not see this?
> 
Unfortunately, my psychic capabilities really lag behind. Really, there
are many rules in many areas in the kernel one can only learn from practice
and from trying, not because it is written down. Where is it written down
how submit patches for inclusion into -stable for anything in the /net
tree ? The one way to find out is to send a request to -stable and get
flamed at for doing so.

> Greg, the reason you get a lot of stable patches seems to be that you
> make it easy to act as a door-mat. Clearly at least some people say "I
> know this patch isn't important enough to send to Linus, but I know
> Greg will silently accept it after the fact, so I'll just wait and
> mark it for stable".
> 
The point isn't really "Greg will silently accept it", but that there
are many unwritten rules which one has to learn. Like with pretty much
everything else, that also applies to -stable submission rules.

I have heard many maintainers state "not critical enough for -rc, I will
submit it in the commit window and mark it for stable". Ok, I started
to follow that approach as well, and you may feel free to shout at me
for doing it.

But, really, folks, it _would_ help if you would consider clarifying the rules.
Which may include more shouting by Greg - after all, we all learn from being
shouted at.

Guenter
