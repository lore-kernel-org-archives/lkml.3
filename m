Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbaFWUSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:18:41 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:61855 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbaFWUSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:18:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140623201503.GA4551@amd.pavel.ucw.cz>
References: <20140621180201.GA4621@amd.pavel.ucw.cz>
	<CAKb7UvhOCiBHcsB6a0qKBNsC3c9pmb=Wc7zucbBuP6vt-tx2eA@mail.gmail.com>
	<20140621194538.GA4903@kroah.com>
	<CAKb7UvjhOystpeRy1nQx49Nspve4wHQPb+e7gJQ-RT-HseK4Cw@mail.gmail.com>
	<20140623130259.GA29809@amd.pavel.ucw.cz>
	<CAKb7UvhmatCtu2rEHgVOjitN1gAPTsgfaUmA2iOLX2Qwhi+Yxg@mail.gmail.com>
	<20140623201503.GA4551@amd.pavel.ucw.cz>
Date: Mon, 23 Jun 2014 16:18:39 -0400
X-Google-Sender-Auth: -DR2vDDXEe2ZSUSPS71_fqvf1uw
Message-ID: <CAKb7UvjU+MvW+rXi8488GE64Exuxj3+H5V+E8fzfL5fTb1CGMA@mail.gmail.com>
Subject: Re: unparseable, undocumented /sys/class/drm/.../pstate
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 4:15 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >> >> > I guess better interface would be something like
>> >> >> >
>> >> >> > pstate/07/core_clock_min
>> >> >> >           core_clock_max
>> >> >> >           memory_clock_min
>> >> >> >           memory_clock_max
>> >> >> >
>> >> >> > and then pstate/active containing just the number of active state?
>> >
>> >> Could we just say that the format of this file is one-per-line of
>> >>
>> >> level: information-for-the-user
>> >
>> > But it is not.
>>
>> But it is...
>>
>> > Management tools will want to parse it, sooner or
>> > later.  What is wrong with solution described above?
>>
>> It is complex and annoying to the people that will actually use it.
>
> grep -r . pstate/ is actually not that bad...

While that's a clever trick that anyone who's done a bunch of stuff
with sysfs knows, I doubt the average linux user could come up with
that on their own. I know I didn't.

>
> And yes, some kind of utility to select right performance level would
> be nice in future... Or maybe not. Perhaps in not so distant future
> kernel will use right performance level for given load...?

Eventually yes. Currently switching between levels varies from
unsupported to unreliable depending on the hardware (as in, hangs the
card, or does otherwise-not-great things). Automatic switching
requires regular switching to be reliable :) [And the performance
counters that are presently being worked on to be able to tell the
card load.]

  -ilia
