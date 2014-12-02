Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbaLBQyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:54:16 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:50022 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356AbaLBQyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:54:14 -0500
MIME-Version: 1.0
In-Reply-To: <20141202163506.GG18921@nuc-i3427.alporthouse.com>
References: <1417533733-2289-1-git-send-email-daniel.vetter@ffwll.ch>
	<1417534582-2977-1-git-send-email-daniel.vetter@ffwll.ch>
	<20141202163506.GG18921@nuc-i3427.alporthouse.com>
Date: Tue, 2 Dec 2014 08:54:13 -0800
Message-ID: <CALAqxLUCD7zxyNrZJnKUE3wbORyZez-bDvScGLXyTjVvvZdinA@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: compute wait_ioctl timeout correctly
From: John Stultz <john.stultz@linaro.org>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 8:35 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Tue, Dec 02, 2014 at 04:36:22PM +0100, Daniel Vetter wrote:
>> +static inline unsigned long nsecs_to_jiffies_timeout(const u64 m)
>> +{
>> +     u64 usecs = div_u64(m + 999, 1000);
>> +     unsigned long j = usecs_to_jiffies(usecs);
>> +
>> +     return min_t(unsigned long, MAX_JIFFY_OFFSET, j + 1);
>
> Or more concisely and review friendly:
>
> static inline unsigned long nsecs_to_jiffies_timeout(const u64 n)
> {
>         return min_t(u64, MAX_JIFFY_OFFSET, nsecs_to_jiffies64(n) + 1);
> }

Yea. This looks much nicer. Seems generic enough it might be better
added next to nsec_to_jiffies64() in kernel/time/time.c or jiffies.h
rather then in a driver header.

And clearly the header comment in nsec_to_jiffies() warning its only
for the scheduler and not for use for drivers (for exactly the reason
of this patch) are not obvious/memorable enough for me and Thomas
makes me wonder if we should change its name to be more clear that its
a sched only function.

thanks
-john
