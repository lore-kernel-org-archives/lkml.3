Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab3HBXZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:25:03 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52772 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab3HBXZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:25:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Felipe Contreras <felipe.contreras@gmail.com>,
        Aaron Lu <aaron.lu@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Zhang Rui <rui.zhang@intel.com>
Cc: Josep Lladonosa <jlladono@gmail.com>, Borislav Petkov <bp@alien8.de>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        lkml <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: i915 backlight
Date: Sat, 03 Aug 2013 01:35:13 +0200
Message-ID: <1542692.FHVXYzeOeb@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAMP44s16-_KA+3JPSzD1CrzcNCuCk4xjOvU6E=gVRxkKiAGr0Q@mail.gmail.com>
References: <20130731162252.GC4724@pd.tnic> <1544218.2BR9ul04Pj@vostro.rjw.lan> <CAMP44s16-_KA+3JPSzD1CrzcNCuCk4xjOvU6E=gVRxkKiAGr0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 02, 2013 01:58:55 PM Felipe Contreras wrote:
> On Fri, Aug 2, 2013 at 9:03 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, August 02, 2013 01:48:37 AM Felipe Contreras wrote:
> >> On Fri, Aug 2, 2013 at 1:25 AM, Josep Lladonosa <jlladono@gmail.com> wrote:
> >> > Hello,
> >> >
> >> > I am using a Lenovo Edge E530 and, with kernel 3.11.0-rc3, I had to
> >> > change to this parameter to the kernel boot:
> >> >
> >> >
> >> > GRUB_CMDLINE_LINUX="acpi_osi=\"!Windows 2012\""
> >>
> >> I think it's pretty obvious that for the time being we need to
> >> blacklist a ton of machines so they boot without this OSI. In fact, in
> >> might make sense to simply remove the OSI completely for all machines
> >> (for now).
> >
> > That would have made sense 6 months ago, but not today.
> 
> Today, like 6 months ago these machines remain broken, and it will be
> the same tomorrow, presumably on v3.11, and at least v3.12 as well.

Can you possibly look at things from a bit broader perspective than just the
broken backlight?

[I'm talking about "simply removing the OSI completely for all machines" if
that's not clear.]

The problem is that for the last 6 months the kernel has responded to
OSI(Windows 2012) with a "yes" and now, after that time, you want it to
make a U turn and start saying "no" even though that may cause problems to
happen on other people's machines.  That's simply irresponsible.

> > The reason is that you don't really know what's affected by that and I'm
> > pretty sure it's not only backlight.
> 
> I haven't heard a single comment that says acpi_osi="!Windows 2012"
> breaks other things. OTOH everybody is saying it fixes the backlight
> problem (if indeed it's the same problem).
> 
> Are you claiming that those users are wrong?

No, they are saying what they see and they are the people having the backlight
problem in the first place.  You have no data from people for whom things work
now.

> > So no, we won't do that.
> 
> Yeah, because that would fix the backlight problems, not tomorrow, or
> several months from now, *today*. Geez, who would want that?
> 
> Here is the patch to fix the problem, *today*.

It doesn't "fix" anything.  It just creates a blacklist of systems where
acpi_osi="!Windows 2012" happens to help with the backlight control problem.

You don't even know why exactly it happens to work on those machines in the
first place and you don't know what is affected by that apart from backlight
(you can't be sure that nothing is affected in particular).

> https://bugzilla.kernel.org/show_bug.cgi?id=60682
> 
> This is what we should do:
> 
> 1) Improve that blacklist list
> 2) Fix the Intel driver issues
> 3) Enable your patch that uses the Intel driver instead
> 4) Remove that patch
> 
> Anything else is not be good for the users.

Actually, the users can easily put the acpi_osi="!Windows 2012" into the
kernel command line (which is what they have been doing already for some
time I suppose).  However, if we add the blacklist to the kernel, that will
mean we kind of give up fixing the backlight control for them (because they
won't have any incentive to test anything else then).

That said this is a controverisal matter and we evidently don't agree with
each other.  I have my reasons, you have your arguments and it doesn't look
like any of us is likely to change his mind, so why don't we do what's
normally done in such cases: Why don't we ask others?

Matthew, Aaron, Rui, what do you think about this?  Should we create an
acpi_osi="!Windows 2012" blacklist of systems where this workaround is known
to help with backlight control issues?  Is this a good idea in your opinion?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
