Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaLCOaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:30:03 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:43650 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbaLCOaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:30:00 -0500
Date: Wed, 3 Dec 2014 15:30:29 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: John Stultz <john.stultz@linaro.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: compute wait_ioctl timeout
 correctly
Message-ID: <20141203143029.GF32117@phenom.ffwll.local>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLUCD7zxyNrZJnKUE3wbORyZez-bDvScGLXyTjVvvZdinA@mail.gmail.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 08:54:13AM -0800, John Stultz wrote:
> On Tue, Dec 2, 2014 at 8:35 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > On Tue, Dec 02, 2014 at 04:36:22PM +0100, Daniel Vetter wrote:
> >> +static inline unsigned long nsecs_to_jiffies_timeout(const u64 m)
> >> +{
> >> +     u64 usecs = div_u64(m + 999, 1000);
> >> +     unsigned long j = usecs_to_jiffies(usecs);
> >> +
> >> +     return min_t(unsigned long, MAX_JIFFY_OFFSET, j + 1);
> >
> > Or more concisely and review friendly:
> >
> > static inline unsigned long nsecs_to_jiffies_timeout(const u64 n)
> > {
> >         return min_t(u64, MAX_JIFFY_OFFSET, nsecs_to_jiffies64(n) + 1);
> > }
> 
> Yea. This looks much nicer. Seems generic enough it might be better
> added next to nsec_to_jiffies64() in kernel/time/time.c or jiffies.h
> rather then in a driver header.

Ok, that needs an EXPORT_SYMBOL for nsecs_to_jiffies64. Can I count your
"Yea" above as an ack for adding that and pulling it in through
drm-intel.git?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
