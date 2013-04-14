Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab3DNVWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 17:22:19 -0400
Received: from toro.web-alm.net ([62.245.132.31]:60384 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab3DNVWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 17:22:18 -0400
Message-ID: <516B1BF9.3000002@osadl.org>
Date: Sun, 14 Apr 2013 23:13:29 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [ANNOUNCE] 3.6.11.1-rt32
References: <1364527527.10629.10.camel@gandalf.local.home>  <515A4CE4.9050607@osadl.org> <1365529616.25498.75.camel@gandalf.local.home>
In-Reply-To: <1365529616.25498.75.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

>>> I'm pleased to announce the 3.6.11.1-rt32 stable release.
>> Unfortunately, there is another compile error:
>> drivers/gpu/drm/i915/i915_gem.c: In function ‘i915_gem_wait_for_error’:
>> drivers/gpu/drm/i915/i915_gem.c:118:3: warning: passing argument 1 of
>> ‘rt_spin_lock’ from incompatible pointer type [enabled by default]
>> In file included from include/linux/spinlock.h:273:0,
>>                    from include/linux/wait.h:24,
>>                    from include/linux/fs.h:396,
>>                    from include/drm/drmP.h:47,
>>                    from drivers/gpu/drm/i915/i915_gem.c:28:
>> [..]
>> I would propose to adopt the mechanism that Sebastian introduced in
>> 3.8.4-rt2 (https://lkml.org/lkml/2013/3/26/600). The kernel compiles
>> and runs without any problem with the below patch on a system that
>> requires the i915 driver module.
> Thanks Carsten, I'll be updating this later today.
Thank you.

> BTW, did you get any core dumps from the work queue race that we've
> been seeing?
No, not yet. Originally, the farm systems did not use crashkernels by
default. I understood that it does no harm but could help in cases like
this one. Therefore, I've started to reconfigure all farm system with
crashkernels - starting with the two systems that had the work queue
race crashes. The kernel messages here (one is a 12-core, the other one
a 32-core box) look exactly like the one 
(https://lkml.org/lkml/2013/3/18/325)
you saw in your 40-core machine (https://lkml.org/lkml/2013/3/18/430).
We'll need to wait for the next crash that will give us a core dump we
may then dissect.

	-Carsten.
