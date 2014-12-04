Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbaLDKmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:42:03 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:47098 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaLDKl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:41:59 -0500
Date: Thu, 4 Dec 2014 11:42:28 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: John Stultz <john.stultz@linaro.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: compute wait_ioctl timeout
 correctly
Message-ID: <20141204104228.GJ32117@phenom.ffwll.local>
Mail-Followup-To: John Stultz <john.stultz@linaro.org>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1417533733-2289-1-git-send-email-daniel.vetter@ffwll.ch>
 <1417534582-2977-1-git-send-email-daniel.vetter@ffwll.ch>
 <20141202163506.GG18921@nuc-i3427.alporthouse.com>
 <CALAqxLUCD7zxyNrZJnKUE3wbORyZez-bDvScGLXyTjVvvZdinA@mail.gmail.com>
 <20141203143029.GF32117@phenom.ffwll.local>
 <CALAqxLUYL91khoW=oLAp_FtPBrDnSazfYqVpkXYTBJsTjDsv+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLUYL91khoW=oLAp_FtPBrDnSazfYqVpkXYTBJsTjDsv+g@mail.gmail.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 11:07:08AM -0800, John Stultz wrote:
> On Wed, Dec 3, 2014 at 6:30 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> > On Tue, Dec 02, 2014 at 08:54:13AM -0800, John Stultz wrote:
> >> On Tue, Dec 2, 2014 at 8:35 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >> > On Tue, Dec 02, 2014 at 04:36:22PM +0100, Daniel Vetter wrote:
> >> >> +static inline unsigned long nsecs_to_jiffies_timeout(const u64 m)
> >> >> +{
> >> >> +     u64 usecs = div_u64(m + 999, 1000);
> >> >> +     unsigned long j = usecs_to_jiffies(usecs);
> >> >> +
> >> >> +     return min_t(unsigned long, MAX_JIFFY_OFFSET, j + 1);
> >> >
> >> > Or more concisely and review friendly:
> >> >
> >> > static inline unsigned long nsecs_to_jiffies_timeout(const u64 n)
> >> > {
> >> >         return min_t(u64, MAX_JIFFY_OFFSET, nsecs_to_jiffies64(n) + 1);
> >> > }
> >>
> >> Yea. This looks much nicer. Seems generic enough it might be better
> >> added next to nsec_to_jiffies64() in kernel/time/time.c or jiffies.h
> >> rather then in a driver header.
> >
> > Ok, that needs an EXPORT_SYMBOL for nsecs_to_jiffies64. Can I count your
> > "Yea" above as an ack for adding that and pulling it in through
> > drm-intel.git?
> 
> Do you need an EXPORT_SYMBOL if you add the _timeout version next to
> nsecs_to_jiffies64 in time.c?

I wouldn't but the patch from Imre to add all the _timeout was killed with
a few bikesheds so really not volunteering. And just moving this single
one doesn't make a lot of sense imo. Also the next patch I'll do is just
add the +1 that we lost to the code and call it a day, really ;-)

> Otherwise no objections to the approach, but I'd like to properly do
> an Acked-by: after I see the patch. :)

I'll send it out.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
