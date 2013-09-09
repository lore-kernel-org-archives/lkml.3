Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab3IIVnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 17:43:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55459 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab3IIVnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 17:43:15 -0400
Date: Mon, 9 Sep 2013 23:42:41 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Viresh Kumar <viresh.kumar@linaro.org>, Greg KH <greg@kroah.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>
Subject: Re: "cpufreq: fix serialization issues with freq change notifiers"
 breaks cpufreq too
In-Reply-To: <1883706.eFcILAzoo8@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.64.1309092330560.12376@axis700.grange>
References: <Pine.LNX.4.64.1309091656200.6602@axis700.grange>
 <1883706.eFcILAzoo8@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:H2XxsKDuBtKqW/U7mvq4b88vyaGlyWLOckW3iRYfDQa
 IC9DQdO9DYeKRjmafXidpxA9bsZJ2ZJ9cAl12RiOg012IV2sVM
 P2qIJknHTbJKhT/ER294bc0QLFRtKCq/jaJkKaI3yO46HgVHRq
 kfdtsxSTAaZDfk1ML7rQX6FmUKJD1iyltOTW0WMaWOH3Z+fDww
 C7ruQUaLkDWl8JNex1HWVRm/EKfHnqcZ/Xo6EKzaVptn+qchBx
 fQ1vZ423AqPLIUvOPewTeE4KZOe5lx8YFkrExJEvOFeVv+BVWW
 W1l4Uv6ng2EW/2uZ4vIDEFc2DS48ZwLga+r2zJZ9VGShNYZ7s5
 Y8WHvn8CU3ahHpnruYUbg7pDnf6bcOr5yi1JNnS0AzkdkhABI2
 La/up8pKvpBQg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael

On Mon, 9 Sep 2013, Rafael J. Wysocki wrote:

> Hi,
> 
> On Monday, September 09, 2013 05:11:10 PM Guennadi Liakhovetski wrote:
> > Sorry guys, I'm trying my best to stop this patch from propagating to 
> > stable and to get it fixed asap, so, the CC list might be a bit excessive. 
> > Also trying to fix the originally spare cc list, which makes it impossible 
> > for me to reply to the original thread, instead have to start a new one.
> 
> I'm not sure what you're talking about.  What exactly was wrong with the
> original CC list in particular?

I think you advised once to cc cpufreq related mails to linux-pm too at 
least. I haven't found this patch in my pm archive, have I missed it 
there?

> > Commit
> > 
> > commit dceff5ce18801dddc220d6238628619c93bc3cb6
> > Author: Viresh Kumar <viresh.kumar@linaro.org>
> > Date:   Sun Sep 1 22:19:37 2013 +0530
> > 
> >     cpufreq: fix serialization issues with freq change notifiers
> > 
> > breaks .transition_ongoing counting.
> 
> Do you know how exactly it breaks that?  If so, care to share that knowledge?

No, I don't. I only know that in __cpufreq_driver_target() the check for

	if (policy->transition_ongoing) {
		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
		return -EBUSY;
	}

is failing with this patch and cpufreq-cpu0.

> > This leads to cpufreq-cpu0 not working any more. In particular switching the
> > governor from performance to powersave directly after boot doesn't result in
> > a frequency switch any more. Reverting this patch fixes the problem again.
> 
> However, this is a regression fix, so I'd prefer to fix the problem on top of
> it instead of reverting this commit entirely.

If I understood correctly, this patch fixed some warnings, that, however, 
didn't disrupt functionality, is this right? Whereas the patch really 
seems to break working set ups.

Anyway, we know about the problem now and I believe it'll get fixed one 
way or another.

Thanks
Guennadi

> > Tested with today's 
> > -next.
> > 
> > Please, refrain from including into "stable" until clarified!
> 
> Well, dropping the commit altogether and dropping the "CC stable" tag are
> equally disruptive at this point, so I think I'll just defer all of the
> cpufreq fixes I wanted to push for 3.12 before the ending of the merge
> window.
> 
> Thanks,
> Rafael
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
