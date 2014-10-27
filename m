Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaJ0WLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 18:11:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:40862 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaJ0WLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 18:11:33 -0400
Date: Mon, 27 Oct 2014 23:11:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: "pang.xunlei" <pang.xunlei@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH RFC 01/12] time: Rename mktime() to mktime_unsafe()
In-Reply-To: <CALAqxLV39LXWO6Lg+q8sU3SbrXh=8=gDqzpF1BGYckXB7Odn6g@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1410272303310.5308@nanos>
References: <1414388748-3333-1-git-send-email-pang.xunlei@linaro.org> <alpine.DEB.2.11.1410272223330.5308@nanos> <CALAqxLV39LXWO6Lg+q8sU3SbrXh=8=gDqzpF1BGYckXB7Odn6g@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, John Stultz wrote:
> On Mon, Oct 27, 2014 at 2:38 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Mon, 27 Oct 2014, pang.xunlei wrote:
> >
> >> The kernel uses 32-bit signed value(time_t) for seconds since 1970-01-01:00:00:00, thus it
> >> will overflow at 2038-01-19 03:14:08 on 32-bit systems. We call this "2038 safety" issue.
> >>
> >> Currently, mktime() deals with "unsigned long" which is 2038 unsafe on 32-bit systems.
> >>
> >> As part of addressing 2038 saftey for in-kernel uses, this patch renames mktime() to
> >> mktime_unsafe(), and changes all its calling users correspondingly. The safe version
> >> of mktime() will be added in the following patch.
> >
> > This is a flag day change. We really want to avoid that. Can we please
> > add a new interface first, then convert all the existing users and
> > kill the old interface.
> >
> > If we really care we can rename it back to the old name once all that
> > has been done, but I personally do not care whether its mktime or
> > mktime64 as long as it is fixed proper.
> 
> This was my bad, as I gave him guidance here. I was hoping to avoid
> doing the one-by-one function renaming dance twice, just to fix the
> function.
> 
> But you're probably right, and someone will probably add a new usage
> right before this gets merged and we'll have some pain there.

It's not only that. The whole series is a purely mechanical approach
to the problem.

Rename A
Fixup some stuff
Rename B
Fixup some more stuff
Rename C
Fixup some more stuff

I completely understand why you tried to take that approach, but TBH
at the point where the "Fixup some more" started to touch the same
file again, you should have noticed that adding intermediate (old
style) timespecs is a non starter as it just introduces another level
of conversion complexity which you wanted to avoid with the
"mechanical" fixup approach in the first place.

Thanks,

	tglx
