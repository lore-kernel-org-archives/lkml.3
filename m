Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934781Ab3DIRrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:47:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26168 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab3DIRq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:46:59 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eIhxMilvRf8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=F0my4ousGMIA:10 a=D19gQVrFAAAA:8 a=Rd9FibQqYsvWXNX05YgA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365529616.25498.75.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.6.11.1-rt32
From: Steven Rostedt <rostedt@goodmis.org>
To: Carsten Emde <C.Emde@osadl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Tue, 09 Apr 2013 13:46:56 -0400
In-Reply-To: <515A4CE4.9050607@osadl.org>
References: <1364527527.10629.10.camel@gandalf.local.home>
	 <515A4CE4.9050607@osadl.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-02 at 05:13 +0200, Carsten Emde wrote:
> Steven,

> > I'm pleased to announce the 3.6.11.1-rt32 stable release.
> Unfortunately, there is another compile error:
> drivers/gpu/drm/i915/i915_gem.c: In function ‘i915_gem_wait_for_error’:
> drivers/gpu/drm/i915/i915_gem.c:118:3: warning: passing argument 1 of 
> ‘rt_spin_lock’ from incompatible pointer type [enabled by default]
> In file included from include/linux/spinlock.h:273:0,
>                   from include/linux/wait.h:24,
>                   from include/linux/fs.h:396,
>                   from include/drm/drmP.h:47,
>                   from drivers/gpu/drm/i915/i915_gem.c:28:
> include/linux/spinlock_rt.h:21:24: note: expected ‘struct spinlock_t *’ 
> but argument is of type ‘struct raw_spinlock_t *’
> drivers/gpu/drm/i915/i915_gem.c:120:3: warning: passing argument 1 of 
> ‘rt_spin_unlock’ from incompatible pointer type [enabled by default]
> In file included from include/linux/spinlock.h:273:0,
>                   from include/linux/wait.h:24,
>                   from include/linux/fs.h:396,
>                   from include/drm/drmP.h:47,
>                   from drivers/gpu/drm/i915/i915_gem.c:28:
> include/linux/spinlock_rt.h:24:24: note: expected ‘struct spinlock_t *’ 
> but argument is of type ‘struct raw_spinlock_t *’
> drivers/gpu/drm/i915/i915_gem.c: In function ‘i915_gem_check_wedge’:
> drivers/gpu/drm/i915/i915_gem.c:1890:3: warning: passing argument 1 of 
> ‘rt_spin_lock’ from incompatible pointer type [enabled by default]
> In file included from include/linux/spinlock.h:273:0,
>                   from include/linux/wait.h:24,
>                   from include/linux/fs.h:396,
>                   from include/drm/drmP.h:47,
>                   from drivers/gpu/drm/i915/i915_gem.c:28:
> include/linux/spinlock_rt.h:21:24: note: expected ‘struct spinlock_t *’ 
> but argument is of type ‘struct raw_spinlock_t *’
> drivers/gpu/drm/i915/i915_gem.c:1892:3: warning: passing argument 1 of 
> ‘rt_spin_unlock’ from incompatible pointer type [enabled by default]
> In file included from include/linux/spinlock.h:273:0,
>                   from include/linux/wait.h:24,
>                   from include/linux/fs.h:396,
>                   from include/drm/drmP.h:47,
>                   from drivers/gpu/drm/i915/i915_gem.c:28:
> include/linux/spinlock_rt.h:24:24: note: expected ‘struct spinlock_t *’ 
> but argument is of type ‘struct raw_spinlock_t *’
> 
> I would propose to adopt the mechanism that Sebastian introduced in
> 3.8.4-rt2 (https://lkml.org/lkml/2013/3/26/600). The kernel compiles
> and runs without any problem with the below patch on a system that
> requires the i915 driver module.
> 

Thanks Carsten, I'll be updating this later today. BTW, did you get any
core dumps from the work queue race that we've been seeing?

Thanks,

-- Steve


