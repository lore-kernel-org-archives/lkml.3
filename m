Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaAXIxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:53:18 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:62124 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaAXIxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:53:14 -0500
MIME-Version: 1.0
In-Reply-To: <20140123140118.GC13345@localhost.localdomain>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
	<CALZhoSRvhqJXU=z=h30SS6USjHFe3yKLsJN9WzQr6ch0sxoN-g@mail.gmail.com>
	<CAKohpokbb3ko3sW4kuDKZSoY1qJ6apVVR3-jpv=7m5ZX__YP8Q@mail.gmail.com>
	<20140120154058.GA9436@localhost.localdomain>
	<CAKohpon=VagQfYauMfb-UH7MQCHATO5i0xDL1_3r=zzpJ4w9zw@mail.gmail.com>
	<20140123140118.GC13345@localhost.localdomain>
Date: Fri, 24 Jan 2014 14:23:13 +0530
Message-ID: <CAKohpom4vuqfVc=Bw1ak0g-7LiVT4rpLcaUTSyACEJb__1O4aQ@mail.gmail.com>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lei Wen <adrian.wenl@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 January 2014 19:31, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Ok, so it is fine to migrate the latter kind I guess?

Unless somebody has abused the API and used bound workqueues where he
should have used unbound ones.

> I haven't checked the details but then this quiesce option would involve
> a dependency on cpuset for any workload involving workqueues affinity. I'm
> not sure we really want this. Besides, workqueues have an existing sysfs interface
> that can be easily extended.
>
> Now indeed we may also want to enforce some policy to make sure that further
> created and queued workqueues are affine to a specific subset of CPUs. And then
> cpuset sounds like a good idea :)

Exactly. Cpuset would be more useful here. Probably we can keep both cpusets
and sysfs interface of workqueues..

I will try to add this option under cpuset which will initially move timers and
workqueues away from the cpuset in question.
