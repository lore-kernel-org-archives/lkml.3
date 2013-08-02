Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3HBWLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 18:11:10 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52709 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800Ab3HBWLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 18:11:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [GIT PULL] ACPI and power management fixes for v3.11-rc4
Date: Sat, 03 Aug 2013 00:21:19 +0200
Message-ID: <6100577.WGRZRabKGy@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAMP44s2DNkkBP4G2oD+yRwxPYUDx6HAQyAEetLkBTe3mEpLR=A@mail.gmail.com>
References: <2052880.bHfzt6NKt5@vostro.rjw.lan> <1820071.Lqgn6ZcLbB@vostro.rjw.lan> <CAMP44s2DNkkBP4G2oD+yRwxPYUDx6HAQyAEetLkBTe3mEpLR=A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 02, 2013 04:31:37 PM Felipe Contreras wrote:
> On Fri, Aug 2, 2013 at 4:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, August 02, 2013 02:12:49 PM Felipe Contreras wrote:
> 
> >> You forgot this patch:
> >>
> >> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&id=3706231332d57072e0e2c0e59975443f3f18e673
> >>
> >> Or do you think it's fine to boot these machines into a black screen?
> >
> > Seriously, what's wrong with you?!
> >
> > I didn't forget about it, I just didn't include it into this particular
> > pull request.
> >
> > And I'm not even sure I will push it for 3.11, because I prefer to revert
> > efaa14c for 3.11 if that's necessary to make your broken box work as before.
> 
> The issue happens in more than just "my broken box", and yes,
> reverting that patch would help (in more than just my box), in the
> sense that at least Linux won't boot into a black screen.
> 
> But the backlight control still wouldn't work, as it hasn't worked
> since v3.7, possibly in many ASUS laptops, for that you need more than
> just reverting efaa14c.

Yes, last time it worked in 3.6 and in particular it doesn't work in 3.10.
My current goal is bring things back to the 3.10 state first, possibly without
introducing any new problems, because we're kind of late in the cycle.
That's better done by reverting stuff known to have introduced problems in
the first place and not by doing things that may introduce more of them.

And your blacklisting patch has potential to introduce problems.  Your goal is
to bring backlight control to the 3.6 state on that particular machine, but
the blacklist is done at the *system* level and very well may affect more
things than just backlight.  You may not see any problems resulting from it
and you may not care even if there are some, but other users of it may use
different user space, for example, and may see problems that you're not seeing.

That's why I'd very much prefer to do the revert at this point.

> > Well, perhaps I just won't push it at all so that you actually can go and
> > complain to Linus about that ...
> 
> That is very responsible from you. Screw the users, right?

No, that's not my goal, sorry for disappointing you.

The problem is that I'm not really convinced about the validity of the
blacklisting approach to begin with.  As I said, the blacklisting is done
on the system level and the goal is to work around backlight control problems.
That sounds like a sledgehammer approach to me, which I don't really like.
If the blacklisting was more targeted, done at the video driver level etc.,
I wouldn't really have any concerns about it, but that's not the case.

And since people evidently could live for over 6 months with the backlight
control problems, maybe they'll survive some more time still and allow us to
find a better approach?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
