Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab3KGD0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 22:26:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55482 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab3KGD0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 22:26:44 -0500
Message-ID: <1383794799.5441.16.camel@marge.simpson.net>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
From: Mike Galbraith <bitbucket@online.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>
Date: Thu, 07 Nov 2013 04:26:39 +0100
In-Reply-To: <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>
References: <1383228427.5272.36.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:5abosToNXzHpBqXCdC3y7nUJ3Eo+XR0Cg8jvpkcDGap
 ndS21q8qP+jl14KUqGcYPm3Y/9qIxXMjaGG+tsQYOUSaXFAm8a
 Kr/vHrohxYhft6ZAjeBT/IPl3QzUM054dL4GPkKNbV6fF0jV0H
 5X+owi3iJ8ZA3H+KOo8OtdgDLucGKrMtoWrXHDjnAQJxW4YZh9
 etd52b+MVywNJ/RV3sFjtq4RjJZW00/MjN+qPrDRNg9Cd2hLcH
 4v2VchjE5L8bjr10Z+tKXVDY4ELOIr9xP30kZ9CMI+9FwH2oRl
 8GTF8C+h1pjvcYfjGKOzyAfaWMUfM3jdo97Xq28geMztT/KzKp
 N5hBhRfO734tN73PjK8M4E5FqRv5H0wiIqHzmQ9SjOEDuzw9LD
 kfNmUfXemwtUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-06 at 18:49 +0100, Thomas Gleixner wrote: 
> On Thu, 31 Oct 2013, Mike Galbraith wrote:
> 
> > Hi Frederic,
> > 
> > The tick wakes ksoftirqd, ensuring nr_running test ain't gonna happen
> > when an otherwise lonely task takes the timer interrupt.  Deferring to
> > softirq processing time..... works.
> 
> -ENOPARSE
> 
> What the heck is this patch doing aside of slapping #ifdeffery all
> over the place?

It ain't a patch, it's a diagnostic.

> I bet you are trying to work around some of the side effects of the
> occasional tick which is still necessary despite of full nohz, right?

Nope, I wanted to check out cost of nohz_full for rt, and found that it
doesn't work at all instead, looked, and found that the sole running
task has just awakened ksoftirqd when it wants to shut the tick down, so
that shutdown never happens. 

> Bah, we want to solve the underlying problems and get rid of the tick
> completely instead of hiding the issues by magic hackery.

That's why I mentioned it.  That ".... works" has a whooooole different
meaning than "this is the fix" :)

-Mike

