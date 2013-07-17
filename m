Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988Ab3GQSOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 14:14:48 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:36129 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab3GQSOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 14:14:45 -0400
Date: Wed, 17 Jul 2013 20:14:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>
Subject: open conflicts vs. hidden conflicts  (was: [ 00/19] 3.10.1-stable
 review)
Message-ID: <20130717181440.GA16955@gmail.com>
References: <20130715155202.GC29526@xanatos>
 <CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com>
 <20130715174659.GC15531@xanatos>
 <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
 <20130715180403.GD15531@xanatos>
 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
 <20130715184642.GE15531@xanatos>
 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
 <20130715195316.GF15531@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715195316.GF15531@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:

> On Mon, Jul 15, 2013 at 12:07:56PM -0700, Linus Torvalds wrote:
> > On Mon, Jul 15, 2013 at 11:46 AM, Sarah Sharp
> > <sarah.a.sharp@linux.intel.com> wrote:
> > >
> > > Bullshit.  I've seen you be polite, and explain to clueless 
> > > maintainers why there's no way you can revert their merge that 
> > > caused regressions, and ask them to fit it without resorting to 
> > > tearing them down emotionally:
> > 
> > Oh, I'll be polite when it's called for.
> > 
> > But when people who know better send me crap, I'll curse at them.
> > 
> > I suspect you'll notice me cursing *way* more at top developers than 
> > random people on the list. I expect more from them, and conversely 
> > I'll be a lot more upset when they do something that I really think 
> > was not great.
> > 
> > For example, my latest cursing explosion was for the x86 maintainers, 
> > and it comes from the fact that I *know* they know to do better. The 
> > x86 tip pulls have generally been through way more testing than most 
> > other pulls I get (not just compiling, but even booting randconfigs 
> > etc). So when an x86 pull request comes in that clearly missed that 
> > expected level of quality, I go to town.
> 
> Good lord.  So anyone that is one of your "top maintainers" could be 
> exposed to your verbal abuse just because they "should have known 
> better"?

As one of those maintainers who sends lots of patches/commits/trees to 
Linus and has done so for the last 15+ years, and as one who has messed up 
enough times to have been grilled by Linus probably more times than anyone 
else in this thread, I guess I should chime in with my first hand 
experience.

In short: you are wrong on many levels.

1)

Your notion that conflicts and insults somehow hurt group cooperation is 
wrong. It is a scientific fact that open conflict _helps_ cooperation 
while hidden conflict hurts it.

There's a famous psychological study that examined the cooperation 
patterns within string quartets playing music (Murnighan & Conlon, 1991): 
it evaluated different string quartets, examining their internal 
'politics' and their conflict resolution techniques.

Effective, successful string quartets embraced open conflict: they 
honestly told each other when they messed up, not avoiding confrontation. 
Open conflict allowed them to eventually play music as a team, 
incorporating the concerns of all the musicians.

'Polite' string quartets on the other hand generally played poorer music, 
because each musician played individually, not as a team. The conflicts 
were never really resolved.

With a quick search I have not found the original study on the open web, 
but here's a citation of it:

  " Murnighan 84 Conlon (1991) found that effective string quartets
    accepted conflict as positive, and incorporated one another's
    concerns into the final product, whereas less successful quartets
    typically avoided conflict."

    http://www.delta.gatech.edu/papers/maximizing.pdf

[ I think this study might explain in part why the high tech industry is 
  so strong in northern Europe: honesty pays off. ]

2)

Your notion that insults are harmful because they 'hurt' is misleading to 
such a level that it's almost wrong.

Insults do hurt of course, but that argument misses the full context: in 
real life the typical substitute for an avoided open conflict is not 
singing kumbaya around the camp fire, but _hidden_ conflict.

Hidden, suppressed conflicts, office politics and passive-aggressive 
behavior are _far_ more harmful than the occasional four letter word:

There was a recent study that showed that 'giving the cold shoulder', 'the 
silent treatment' and other forms of passive-aggressive violence activate 
exactly the same brain regions as being physically injured. (!)

The difference between Linus's chiding of maintainers who messed up and 
'hidden' conflicts is significant:

  1) passive-aggressive violence can go on essentially forever, without
     outsiders noticing it. You won't notice it even on lkml, and yes, it 
     occurs all the time ...

  2) passive-aggressive violence _thrives_ in 'polite', 'professional'
     environments that supress open conflict. Hidden violence also occurs 
     in a lot of 'polite' open source projects that I know.

  3) so the net duration of the conflict is _far_ shorter in the Linus
     case.

I will pick an honest, colorful Linus flame over workplace mobbing or 
other forms of substitute passive-aggressive violence any time of the day.

3)

I couldn't cite a single example where Linus flamed me unprovoked, 
unjustified, just for the sake of letting off steam or any other petty 
reason. I've not seen Linus flame newbies and I've not seen him 
micro-manage people over unimportant details.

In the large majority of colorful flames the flame was over something that 
_matters to the kernel_ - and heck do I prefer a top level maintainer who 
cares and who is honest, over someone who is indifferent or sloppy ...

Thanks,

	Ingo
