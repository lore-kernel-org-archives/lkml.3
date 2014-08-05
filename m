Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaHEU5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 16:57:04 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:60598 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaHEU5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 16:57:01 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwvRcr98M=425eCR8K04X-uAVjH2bs3hudkySVKM4VqVg@mail.gmail.com>
References: <20140730014827.565626091@linuxfoundation.org>
	<20140730014829.344302554@linuxfoundation.org>
	<20140730065312.GA1652@laptop.redhat.com>
	<CA+55aFzr_wJzt6RpojXpDo-ashV_N7sP+j7Ba0ND9mSpr7MKRQ@mail.gmail.com>
	<CA+5PVA5FPD8hp_7=M-VNoUG1Mw9R0Xkn2Yo50eo28ojzrcB5Aw@mail.gmail.com>
	<CA+55aFwvRcr98M=425eCR8K04X-uAVjH2bs3hudkySVKM4VqVg@mail.gmail.com>
Date: Tue, 5 Aug 2014 16:57:00 -0400
X-Google-Sender-Auth: 3a4_Ajl4yVQ3KgaORc2BWqKaJug
Message-ID: <CA+5PVA79a-BoMMAzryH0O3NFz6KY1f9REAmE=T00ErfcUfCGEg@mail.gmail.com>
Subject: Re: [PATCH 3.15 33/37] Fix gcc-4.9.0 miscompilation of load_balance()
 in scheduler
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jakub Jelinek <jakub@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        "Frank Ch. Eigler" <fche@redhat.com>, Josh Stone <jistone@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2014 at 12:49 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Aug 5, 2014 at 4:31 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>>
>> Sorry to bring this back up after the fact, but it's important for a
>> number of things in various distros
>
> You said that before, and I ignored you before, because you didn't
> actually give any examples.

Actually, I haven't said anything on this until now.  You are perhaps
thinking of someone else.  I haven't participated in this thread until
today.

>>.  I don't disagree it should be
>> disabled by default, but making it unconditional is going to force the
>> distributions that care about perf, systemtap, and debuggers to
>> manually revert this.
>
> Bah. I bet I use 'perf' more than most, and it doesn't care about
> debug info. Sure, if you want the annotated source code, or put probes
> in place, you want the line number information, but the amount of
> debug information it needs is miniscule, and not impacted bu this at
> all afaik.
>
> And systemtap people have more problems than this.

They might have more problems, but they're telling me this breaks
systemtap full stop.  AFAIK, systemtap needs to put probes in place
for it to work.  I've added a couple systemtap developers on CC again,
and Jakub has an earlier post as well.  Hopefully they can expand upon
it.  If they can't, then things become simpler.

> Debuggers? Again, people who actually use kgdb have bigger issues than
> some slightly worse local variable tracking.  People care about the
> frame pointer information and type information, but if you use kgdb on
> the kernel you can damn well look at the assembly code and source code
> annotation for local variable information.
>
> So I call bullshit. Give a real example of real-world use, not some
> random handwaving of cases that happen to use debug info but - at
> least for the kernel - don't actually care about the variable
> tracking.

I'm not here to convince you that kernel developers need this option
set.  I doubt they do, and I'm not sure I could make a convincing
argument around that anyway.  But I'm also being told by the teams I
work with that this breaks something that previously worked for them,
and I'm asking if it can be conditionally enabled instead of blindly
defaulting to off.  Distros do terrible things like patch their gcc
with pre-release patches to fix issues, and giving the distros the
option of enabling this is all I'm after.

> The variable tracking is absolutely the *least* important part of the
> debug info. By a huge margin. To the point of being entirely
> irrelevant for the kernel. You make it sound like you lose all debug
> information, when in reality that's not the case at all.

I don't think I said that.  I said distros that care about the things
this enables in perf and systemtap are going to have to carry a revert
(assuming what I've been told is valid).  It's unnecessary deviation
form upstream because you decided you didn't give a crap about this
particular thing and thinks it's a waste of time.  Frankly, I don't
give a crap about it either but I do give a crap about people no
longer being able to use my distro kernels without that revert for
something that worked just fine before.  The distro knows when their
gcc packages have been fixed.

> Trust me, you lose *way* more debug information because the kernel
> uses "-O2" rather than "-O".

I'm not arguing it's useful.  I'm asking you to let distros to
continue to make the horrible choices they make so the things they
ship will work.  I don't think that's being unreasonable.

josh
