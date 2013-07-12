Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155Ab3GLRFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:05:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965067Ab3GLRFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:05:33 -0400
Date: Fri, 12 Jul 2013 10:05:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Guenter Roeck <linux@roeck-us.net>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130712170532.GA5656@kroah.com>
References: <20130711214830.611455274@linuxfoundation.org>
 <20130711222935.GA11340@redhat.com>
 <20130711224455.GA17222@kroah.com>
 <20130712141530.GA3629@roeck-us.net>
 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
 <1373644044.17876.92.camel@gandalf.local.home>
 <CA+55aFxUZCWT55EZ7fZw0j_UgaqjPA8Wiv47s5qO01NvHNzFCQ@mail.gmail.com>
 <20130712161708.GA3759@gmail.com>
 <CA+5PVA6k8xQR4uCpiCnYD3iz421XHGX9eV8vNDH3y1t092aAdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA6k8xQR4uCpiCnYD3iz421XHGX9eV8vNDH3y1t092aAdw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 12:35:26PM -0400, Josh Boyer wrote:
> On Fri, Jul 12, 2013 at 12:17 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> >> On Fri, Jul 12, 2013 at 8:47 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >> >
> >> > I tend to hold things off after -rc4 because you scare me more than Greg
> >> > does ;-)
> >>
> >> Have you guys *seen* Greg? The guy is a freakish giant. He *should*
> >> scare you. He might squish you without ever even noticing.
> >
> > Greg might be a giant and he might squish people without ever even
> > noticing, but that's just a grave, deadly physical threat no real kernel
> > hacker ever feels threatened by. (Not much can hurt us deep in our dark
> > basements after all, except maybe earthquakes, gamma ray eruptions and Mom
> > trying to clean up around the computers.)
> >
> > So Greg, if you want it all to change, create some _real_ threat: be frank
> > with contributors and sometimes swear a bit. That will cut your mailqueue
> > in half, promise!

Ok, I'll channel my "inner Linus" and take a cue from my kids and start
swearing more.

> I don't think it's that simple.  The problem here isn't that Greg is
> being too nice.  The problem is that people are holding back fixes
> from Linus' tree.  Greg might be able to yell at maintainers more, but
> if he does it's after the fact and it's sort of a too late situation.
> Those fixes should probably get in the tree because they should
> probably have been in the .0 release to begin with.  I don't envy Greg
> here.

I'm going to start pushing back on the "obviously this shouldn't be for
stable" patches, and have done so, but you are right, the real issue is
that it seems that subsystem maintainers are being lazy and just not
sending the patches to Linus at all, because they "know" I will pick
them up for the .1 or .2 release.

Specific example is, again, the powerpc patches.  Out of 21 patches
marked for stable that showed up in the -rc1 merge, at least 7 of them
had _plenty_ of time to get into 3.10.0 as they are weeks, and sometimes
months, old.  Some of the other ones seem _very_ new, being only days
old before they hit Linus's tree, which makes me worry about them for
totally different reasons (i.e. not tested in linux-next at all.)

I can put a "delay" on patches to not hit a stable release for a few
weeks until they get some testing in Linus's tree, but in reality,
what's that going to help with?

I guess I can just not apply them at all, tough-love and all that, but
that just puts an extra burden on the distro kernel maintainers to have
to go dig up the fixes for their users.

Although really, who cares about powerpc anymore :)

> More seriously though, those -stable fixes queued up for months show
> up there first.  Perhaps if we watch the trees feeding into linux-next
> for a bit for fixes tagged with -stable in the middle -rc windows, we
> can prod maintainers more.

Someone once did this, and I agree, it should be done more.  I'll see
about knocking up a script to try to automate it a bit to make it easier
for me to do that.  Dave has proven that we need to poke maintainers
more to get their act together and push fixes to Linus.

greg k-h
