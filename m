Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab3HCBBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 21:01:30 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:52529 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab3HCBB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 21:01:29 -0400
MIME-Version: 1.0
In-Reply-To: <1542692.FHVXYzeOeb@vostro.rjw.lan>
References: <20130731162252.GC4724@pd.tnic>
	<1544218.2BR9ul04Pj@vostro.rjw.lan>
	<CAMP44s16-_KA+3JPSzD1CrzcNCuCk4xjOvU6E=gVRxkKiAGr0Q@mail.gmail.com>
	<1542692.FHVXYzeOeb@vostro.rjw.lan>
Date: Fri, 2 Aug 2013 20:01:25 -0500
Message-ID: <CAMP44s1m7P6fDqcmdqLoGo5+xcgXVJPpKTM+cnENuX4EmnFaZA@mail.gmail.com>
Subject: Re: i915 backlight
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aaron Lu <aaron.lu@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Zhang Rui <rui.zhang@intel.com>, Josep Lladonosa <jlladono@gmail.com>,
        Borislav Petkov <bp@alien8.de>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 6:35 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, August 02, 2013 01:58:55 PM Felipe Contreras wrote:
>> On Fri, Aug 2, 2013 at 9:03 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Friday, August 02, 2013 01:48:37 AM Felipe Contreras wrote:

>> >> I think it's pretty obvious that for the time being we need to
>> >> blacklist a ton of machines so they boot without this OSI. In fact, in
>> >> might make sense to simply remove the OSI completely for all machines
>> >> (for now).
>> >
>> > That would have made sense 6 months ago, but not today.
>>
>> Today, like 6 months ago these machines remain broken, and it will be
>> the same tomorrow, presumably on v3.11, and at least v3.12 as well.
>
> Can you possibly look at things from a bit broader perspective than just the
> broken backlight?
>
> [I'm talking about "simply removing the OSI completely for all machines" if
> that's not clear.]
>
> The problem is that for the last 6 months the kernel has responded to
> OSI(Windows 2012) with a "yes" and now, after that time, you want it to
> make a U turn and start saying "no" even though that may cause problems to
> happen on other people's machines.  That's simply irresponsible.

The difference is we *know* *for sure* responding "Windows 2012" with
a yes causes problems, on the other hand you *think* responding with a
no, *might* cause problems.

The only reason it would make sense to remain in the current situation
is that if *knew* that switching to no would cause problems, but to my
knowledge such problems are not real, merely theoretical.

We have had proven brokedness for four releases (almost five now), if
you disable it for v3.12 and it turns out it causes even more
problems, then you enable it back again for v3.13, or even v3.12.1.
The only way to know for certain is to go ahead and try it.

But we know it's going to be all right, because v3.6 was all right.

>> > The reason is that you don't really know what's affected by that and I'm
>> > pretty sure it's not only backlight.
>>
>> I haven't heard a single comment that says acpi_osi="!Windows 2012"
>> breaks other things. OTOH everybody is saying it fixes the backlight
>> problem (if indeed it's the same problem).
>>
>> Are you claiming that those users are wrong?
>
> No, they are saying what they see and they are the people having the backlight
> problem in the first place.  You have no data from people for whom things work
> now.

The data comes from v3.6, who complained? Anyway, it's easy to find
out; just disable it for *one release*.

>> > So no, we won't do that.
>>
>> Yeah, because that would fix the backlight problems, not tomorrow, or
>> several months from now, *today*. Geez, who would want that?
>>
>> Here is the patch to fix the problem, *today*.
>
> It doesn't "fix" anything.  It just creates a blacklist of systems where
> acpi_osi="!Windows 2012" happens to help with the backlight control problem.

>From the user's point of view; right now it doesn't work, after the
patch it does. That is a fix.

> You don't even know why exactly it happens to work on those machines in the
> first place and you don't know what is affected by that apart from backlight
> (you can't be sure that nothing is affected in particular).

I have a fairly good idea of the *real* problems involved with the backlight.

The other problems you speak of are hypothetical, and yes, I don't
know if there will be more problems, but neither do you. This is an
argument from ignorance fallacy, and it's easy to solve; let's try it
for one release and see how it goes. Then we would *know*.

>> https://bugzilla.kernel.org/show_bug.cgi?id=60682
>>
>> This is what we should do:
>>
>> 1) Improve that blacklist list
>> 2) Fix the Intel driver issues
>> 3) Enable your patch that uses the Intel driver instead
>> 4) Remove that patch
>>
>> Anything else is not be good for the users.
>
> Actually, the users can easily put the acpi_osi="!Windows 2012" into the
> kernel command line (which is what they have been doing already for some
> time I suppose).

The kernel should just work out-of-the-box. You can't expect every
user out there to put all sorts of quirks into their boot command,
that's why we have quirks in the kernel in the first place.

> However, if we add the blacklist to the kernel, that will
> mean we kind of give up fixing the backlight control for them (because they
> won't have any incentive to test anything else then).

No, it doesn't mean that.

You should not break systems willingly and knowingly only to create
incentives to the developers.

When things are ready, you enable the fix again, if they break, you
disable it again. At no point in time does it make sense to retain
code that we know breaks user-experience.

> That said this is a controverisal matter and we evidently don't agree with
> each other.  I have my reasons, you have your arguments and it doesn't look
> like any of us is likely to change his mind, so why don't we do what's
> normally done in such cases: Why don't we ask others?
>
> Matthew, Aaron, Rui, what do you think about this?  Should we create an
> acpi_osi="!Windows 2012" blacklist of systems where this workaround is known
> to help with backlight control issues?  Is this a good idea in your opinion?

Mind that the suggestion is to do this *temporarily*, until there's
more certainty that the proper fix works.

-- 
Felipe Contreras
