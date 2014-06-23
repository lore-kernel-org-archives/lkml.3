Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaFWQHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:07:39 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55422 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753835AbaFWQHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:07:38 -0400
X-Sasl-enc: v2154CZirzbGwE/9d7lILu6ywlCGEwYeTTJOVSpuxwRi 1403539657
Date: Mon, 23 Jun 2014 12:07:27 -0400
From: Greg KH <greg@kroah.com>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: unparseable, undocumented /sys/class/drm/.../pstate
Message-ID: <20140623160727.GA19557@kroah.com>
References: <20140621180201.GA4621@amd.pavel.ucw.cz>
 <CAKb7UvhOCiBHcsB6a0qKBNsC3c9pmb=Wc7zucbBuP6vt-tx2eA@mail.gmail.com>
 <20140621194538.GA4903@kroah.com>
 <CAKb7UvjhOystpeRy1nQx49Nspve4wHQPb+e7gJQ-RT-HseK4Cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKb7UvjhOystpeRy1nQx49Nspve4wHQPb+e7gJQ-RT-HseK4Cw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2014 at 10:12:14PM -0400, Ilia Mirkin wrote:
> On Sat, Jun 21, 2014 at 3:45 PM, Greg KH <greg@kroah.com> wrote:
> > On Sat, Jun 21, 2014 at 02:22:59PM -0400, Ilia Mirkin wrote:
> >> On Sat, Jun 21, 2014 at 2:02 PM, Pavel Machek <pavel@ucw.cz> wrote:
> >> > Hi!
> >> >
> >> > AFAICT, pstate file will contain something like
> >> >
> >> > 07: core 100 MHz memory 123 MHz *
> >> > 08: core 100-200 MHz memory 123 MHz
> >> >
> >> > ...which does not look exactly like one-value-per-file, and I'm pretty
> >> > sure userspace will get it wrong if it tries to parse it. Plus, I
> >> > don't see required documentation in Documentation/ABI.
> >> >
> >> > Should we disable it for now, so that userspace does not start
> >> > depending on it and we'll not have to maintain it forever?
> >> >
> >> > I guess better interface would be something like
> >> >
> >> > pstate/07/core_clock_min
> >> >           core_clock_max
> >> >           memory_clock_min
> >> >           memory_clock_max
> >> >
> >> > and then pstate/active containing just the number of active state?
> >> >
> >> > Thanks,
> >> >                                                                 Pavel
> >> >
> >> > PS: I have no nvidia, got the news at
> >> >
> >> > http://www.phoronix.com/scan.php?page=article&item=nouveau_try_linux316&num=2
> >>
> >> FTR, this file has been in place since 3.13, and there was a different
> >> file before it (performance_levels), with a comparable format since
> >> much earlier (definitely 3.8, probably earlier). I think it's meant a
> >> lot more for people looking at it and echo'ing stuff to it to modify
> >> the levels (where supported), than for programs parsing it. Perhaps
> >> sysfs is the wrong place for this -- what is the right place? debugfs?
> >
> > Yes, please move it to debugfs.
> 
> Could we just say that the format of this file is one-per-line of
> 
> level: information-for-the-user
> 
> And you can echo a level into it to switch to that level? That seems
> like a reasonable ABI to have... would be happy to throw it into a
> file somewhere... not sure where though.

sysfs files are "one value per file", that's it.  Do anything other than
that, and it can not be in sysfs, sorry.

greg k-h
