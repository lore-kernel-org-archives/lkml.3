Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaBTV4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:56:10 -0500
Received: from www.linutronix.de ([62.245.132.108]:34811 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbaBTV4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:56:09 -0500
Date: Thu, 20 Feb 2014 22:56:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: Alexey Perevalov <a.perevalov@samsung.com>, linux-kernel@vger.kernel.org,
        anton@nomsg.org, kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v3 2/6] hrtimer: Add support for deferrable timer into
 the hrtimer
In-Reply-To: <5306718E.9080803@linaro.org>
Message-ID: <alpine.DEB.2.02.1402202254450.4468@ionos.tec.linutronix.de>
References: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com> <1392885633-7787-3-git-send-email-a.perevalov@samsung.com> <53064E4A.8030105@linaro.org> <alpine.DEB.2.02.1402202216350.4468@ionos.tec.linutronix.de> <5306718E.9080803@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, John Stultz wrote:
> On 02/20/2014 01:18 PM, Thomas Gleixner wrote:
> > On Thu, 20 Feb 2014, John Stultz wrote:
> >> On 02/20/2014 12:40 AM, Alexey Perevalov wrote:
> >>> diff --git a/include/uapi/linux/time.h b/include/uapi/linux/time.h
> >>> index e75e1b6..bb8dc60 100644
> >>> --- a/include/uapi/linux/time.h
> >>> +++ b/include/uapi/linux/time.h
> >>> @@ -56,6 +56,9 @@ struct itimerval {
> >>>  #define CLOCK_BOOTTIME_ALARM		9
> >>>  #define CLOCK_SGI_CYCLE			10	/* Hardware specific */
> >>>  #define CLOCK_TAI			11
> >>> +#define CLOCK_REALTIME_DEFERRABLE	12
> >>> +#define CLOCK_MONOTONIC_DEFERRABLE	13
> >>> +#define CLOCK_BOOTTIME_DEFERRABLE	14
> >> Adding the deferrable HRTIMER bases above is right, but I don't think we
> >> agreed on adding the _DEFERRABLE clockids.
> >>
> >> I'd instead prefer you use add a new TIMER_DEFERABLE flags argument, and
> >> use the combination of the clockid + flag to decide which HRTIMER base
> >> is used.
> > And how does that work with anything else than timerfd? If we add
> > deferrable posix clocks then we add them for the other interfaces
> > which take a clockid as well.
> Other interfaces have flag arguments as well (for things like
> TIMER_ABSTIME).

Fair enough. Let me look tomorrow what implications that
has. Definitely a bit more intrusive, but probably more elegant.

Thanks,

	tglx
