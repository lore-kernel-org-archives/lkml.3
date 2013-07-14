Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3GNWlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 18:41:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:42816 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab3GNWlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 18:41:15 -0400
Message-ID: <1373841642.19894.286.camel@pasglop>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Josh Boyer <jwboyer@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Guenter Roeck <linux@roeck-us.net>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Date: Mon, 15 Jul 2013 08:40:42 +1000
In-Reply-To: <20130712170532.GA5656@kroah.com>
References: <20130711214830.611455274@linuxfoundation.org>
	 <20130711222935.GA11340@redhat.com> <20130711224455.GA17222@kroah.com>
	 <20130712141530.GA3629@roeck-us.net>
	 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
	 <1373644044.17876.92.camel@gandalf.local.home>
	 <CA+55aFxUZCWT55EZ7fZw0j_UgaqjPA8Wiv47s5qO01NvHNzFCQ@mail.gmail.com>
	 <20130712161708.GA3759@gmail.com>
	 <CA+5PVA6k8xQR4uCpiCnYD3iz421XHGX9eV8vNDH3y1t092aAdw@mail.gmail.com>
	 <20130712170532.GA5656@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-12 at 10:05 -0700, Greg Kroah-Hartman wrote:
> Specific example is, again, the powerpc patches.  Out of 21 patches
> marked for stable that showed up in the -rc1 merge, at least 7 of them
> had _plenty_ of time to get into 3.10.0 as they are weeks, and sometimes
> months, old.  Some of the other ones seem _very_ new, being only days
> old before they hit Linus's tree, which makes me worry about them for
> totally different reasons (i.e. not tested in linux-next at all.)

So for the old ones that's me not actively sending you stuff that has a
CC stable tag when I merge it. I should probably fix that indeed. This
is especially true of (but not exclusively) stuff that I don't apply
myself but merge via somebody else branch.

For the new stuff, this is a combinations of some last minute fuckups
which are pretty specific to 3.10 and for which I'm in part responsible,
and in part due to us basically ramping up testing on Power8 and getting
ready for the next RHEL & SLES at the same time, thus doing more testing
internally.

You'll notice that a lot of that stuff is P8 support so testing in
"next" isn't going to help much since nobody outside of IBM has access
to these guys yet. We are getting the stuff out there due to distro
unrealistic expectations of having upstream code for new machines years
before a release.

Also keep in mind that sometimes, that stuff has been around on
patchwork for a while and got tested by various people, but the patch
got a last minute rev of improved changeset comment or cosmetic polish.

> I can put a "delay" on patches to not hit a stable release for a few
> weeks until they get some testing in Linus's tree, but in reality,
> what's that going to help with?

Depends. In some of the patches I put in for stable, they fix something
that 3.10 broke and the fixes are quite self-contained, waiting makes no
sense.

At some stage I make a judgement call on a given patch, how "obvious"
the fix is (I know they never are completely ... well most of the time),
how invasive it is, what risk it represents outside of the are that it
"fixes". I do mistakes, but generally I am fairly conservative in that
area.

> I guess I can just not apply them at all, tough-love and all that, but
> that just puts an extra burden on the distro kernel maintainers to have
> to go dig up the fixes for their users.

You know how the distro can be about that... especially when they invent
idiotic junk such as kABI which prevents you from fixing things properly
for the sake of [probably illegal] binary drivers, and so on... Distro
seem to enjoy establishing a process that guarantee that an "enterprise
release" is entirely comprise of utter junk (not even talking about all
the in-house untested broken stupid crap they add to their kernels while
at the same time being hard-ass with fixes coming from the vendors).

> Although really, who cares about powerpc anymore :)

That was unfair :-)

Cheers,
Ben.


