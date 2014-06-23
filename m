Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbaFWNDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:03:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39498 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaFWNDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:03:01 -0400
Date: Mon, 23 Jun 2014 15:02:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: unparseable, undocumented /sys/class/drm/.../pstate
Message-ID: <20140623130259.GA29809@amd.pavel.ucw.cz>
References: <20140621180201.GA4621@amd.pavel.ucw.cz>
 <CAKb7UvhOCiBHcsB6a0qKBNsC3c9pmb=Wc7zucbBuP6vt-tx2eA@mail.gmail.com>
 <20140621194538.GA4903@kroah.com>
 <CAKb7UvjhOystpeRy1nQx49Nspve4wHQPb+e7gJQ-RT-HseK4Cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKb7UvjhOystpeRy1nQx49Nspve4wHQPb+e7gJQ-RT-HseK4Cw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-06-22 22:12:14, Ilia Mirkin wrote:
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

> Could we just say that the format of this file is one-per-line of
> 
> level: information-for-the-user

But it is not. Management tools will want to parse it, sooner or
later.  What is wrong with solution described above?

> And you can echo a level into it to switch to that level? That seems
> like a reasonable ABI to have... would be happy to throw it into a
> file somewhere... not sure where though.

Documentation/ABI/testing/

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
