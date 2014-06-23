Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbaFWUcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:32:31 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:62152 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbaFWUca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:32:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140623202615.GA29199@kroah.com>
References: <20140621180201.GA4621@amd.pavel.ucw.cz>
	<CAKb7UvhOCiBHcsB6a0qKBNsC3c9pmb=Wc7zucbBuP6vt-tx2eA@mail.gmail.com>
	<20140621194538.GA4903@kroah.com>
	<CAKb7UvjhOystpeRy1nQx49Nspve4wHQPb+e7gJQ-RT-HseK4Cw@mail.gmail.com>
	<20140623130259.GA29809@amd.pavel.ucw.cz>
	<CAKb7UvhmatCtu2rEHgVOjitN1gAPTsgfaUmA2iOLX2Qwhi+Yxg@mail.gmail.com>
	<20140623201503.GA4551@amd.pavel.ucw.cz>
	<CAKb7UvjU+MvW+rXi8488GE64Exuxj3+H5V+E8fzfL5fTb1CGMA@mail.gmail.com>
	<20140623202615.GA29199@kroah.com>
Date: Mon, 23 Jun 2014 16:32:29 -0400
X-Google-Sender-Auth: MZvoZ0ssd6aOi6j57nUjrRJRIDE
Message-ID: <CAKb7UvjtQccXkGZGtAk6+FA2v+SL9ud4Rjz35jFq6=kdbJKXGA@mail.gmail.com>
Subject: Re: unparseable, undocumented /sys/class/drm/.../pstate
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Greg KH <greg@kroah.com>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 4:26 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Jun 23, 2014 at 04:18:39PM -0400, Ilia Mirkin wrote:
>> On Mon, Jun 23, 2014 at 4:15 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> > Hi!
>> >
>> >> >> >> > I guess better interface would be something like
>> >> >> >> >
>> >> >> >> > pstate/07/core_clock_min
>> >> >> >> >           core_clock_max
>> >> >> >> >           memory_clock_min
>> >> >> >> >           memory_clock_max
>> >> >> >> >
>> >> >> >> > and then pstate/active containing just the number of active state?
>> >> >
>> >> >> Could we just say that the format of this file is one-per-line of
>> >> >>
>> >> >> level: information-for-the-user
>> >> >
>> >> > But it is not.
>> >>
>> >> But it is...
>> >>
>> >> > Management tools will want to parse it, sooner or
>> >> > later.  What is wrong with solution described above?
>> >>
>> >> It is complex and annoying to the people that will actually use it.
>> >
>> > grep -r . pstate/ is actually not that bad...
>>
>> While that's a clever trick that anyone who's done a bunch of stuff
>> with sysfs knows, I doubt the average linux user could come up with
>> that on their own. I know I didn't.
>
> That's fine, why would an "average" Linux user ever need to poke around
> in sysfs?  Again, please describe what you are wanting to have exported
> to userspace, and what userspace is supposed to do with that
> information, before worrying about the actual sysfs file layout.

It would be nice to allow the end-user to switch between performance
levels on the card.

A particular card exposes some number of levels (well, a particular
card's VBIOS), identified by a value between 0-254 (usually identified
as a 2-char hex string). Each level has various information associated
with it, like timing parameters for various bits of the card, as well
as some more user-friendly concepts like "memory clock speed" etc.

The card's current state may or may not correspond to one of the
predefined levels; often-times the VBIOS initializes the card into
some non-level state. This state may also be of some interest to the
user.

We can't switch to arbitrary speeds, only the defined ones (because of
the various other timing parameters). The level ids don't carry too
much semantic value (higher usually means faster though), so it would
additionally be nice to tell the user some of the more user-friendly
information about each level. Different hardware versions will be able
to expose different types of information (but always in <name> <clock
speed/range> pairs).

  -ilia
