Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaFWCMQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 22:12:16 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:64398 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaFWCMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 22:12:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140621194538.GA4903@kroah.com>
References: <20140621180201.GA4621@amd.pavel.ucw.cz>
	<CAKb7UvhOCiBHcsB6a0qKBNsC3c9pmb=Wc7zucbBuP6vt-tx2eA@mail.gmail.com>
	<20140621194538.GA4903@kroah.com>
Date: Sun, 22 Jun 2014 22:12:14 -0400
X-Google-Sender-Auth: ETp4TIheJfk0bwlOJ1fDhmry2Mo
Message-ID: <CAKb7UvjhOystpeRy1nQx49Nspve4wHQPb+e7gJQ-RT-HseK4Cw@mail.gmail.com>
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

On Sat, Jun 21, 2014 at 3:45 PM, Greg KH <greg@kroah.com> wrote:
> On Sat, Jun 21, 2014 at 02:22:59PM -0400, Ilia Mirkin wrote:
>> On Sat, Jun 21, 2014 at 2:02 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> > Hi!
>> >
>> > AFAICT, pstate file will contain something like
>> >
>> > 07: core 100 MHz memory 123 MHz *
>> > 08: core 100-200 MHz memory 123 MHz
>> >
>> > ...which does not look exactly like one-value-per-file, and I'm pretty
>> > sure userspace will get it wrong if it tries to parse it. Plus, I
>> > don't see required documentation in Documentation/ABI.
>> >
>> > Should we disable it for now, so that userspace does not start
>> > depending on it and we'll not have to maintain it forever?
>> >
>> > I guess better interface would be something like
>> >
>> > pstate/07/core_clock_min
>> >           core_clock_max
>> >           memory_clock_min
>> >           memory_clock_max
>> >
>> > and then pstate/active containing just the number of active state?
>> >
>> > Thanks,
>> >                                                                 Pavel
>> >
>> > PS: I have no nvidia, got the news at
>> >
>> > http://www.phoronix.com/scan.php?page=article&item=nouveau_try_linux316&num=2
>>
>> FTR, this file has been in place since 3.13, and there was a different
>> file before it (performance_levels), with a comparable format since
>> much earlier (definitely 3.8, probably earlier). I think it's meant a
>> lot more for people looking at it and echo'ing stuff to it to modify
>> the levels (where supported), than for programs parsing it. Perhaps
>> sysfs is the wrong place for this -- what is the right place? debugfs?
>
> Yes, please move it to debugfs.

Could we just say that the format of this file is one-per-line of

level: information-for-the-user

And you can echo a level into it to switch to that level? That seems
like a reasonable ABI to have... would be happy to throw it into a
file somewhere... not sure where though.

  -ilia
