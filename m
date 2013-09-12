Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab3ILUVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:21:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:60930 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab3ILUVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:21:13 -0400
Date: Thu, 12 Sep 2013 22:20:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
cc: Peter Zijlstra <peterz@infradead.org>, Dave Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [BUG] completely bonkers use of set_need_resched +
 VM_FAULT_NOPAGE
In-Reply-To: <CAKMK7uHJansZzKxrr8p0c2X5pEeb-BSxLa6=tnsDmwo-k__Xcg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1309122219370.4089@ionos.tec.linutronix.de>
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net> <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com> <20130912154329.GB31370@twins.programming.kicks-ass.net> <CAKMK7uFTYB-E5ksVNEBqGJusJ5TKJv5X4hiPv1mno9tJKuUAdA@mail.gmail.com>
 <20130912162210.GE31370@twins.programming.kicks-ass.net> <CAKMK7uGsgYOtKQrCoq26RV9a_8na14sbpanUxM2_3EBwz-3vVw@mail.gmail.com> <alpine.DEB.2.02.1309122157300.4089@ionos.tec.linutronix.de> <CAKMK7uHJansZzKxrr8p0c2X5pEeb-BSxLa6=tnsDmwo-k__Xcg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Daniel Vetter wrote:

> On Thu, Sep 12, 2013 at 9:58 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> >> On Thu, Sep 12, 2013 at 6:22 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> > If 'sane' userspace is never supposed to do this, then only insane
> >> > userspace is going to hurt from this and that's a GOOD (tm) thing,
> >> > right? ;-)
> >>
> >> Afaik sane userspace doesn't hit the _deadlock_ (or lifelock if we
> >> have the set_need_resched in there). drm/i915 is a bit different since
> >> we have just one lock, and so the same design would actually deadlock
> >> even for sane userspace. But hitting contention there and yielding is
> >> somewhat expected. Obviously shouldn't happen too often since it'll
> >> hurt performance, with either blocking or the yield spinning loop.
> >
> > So this is actually a non priviledged DoS interface, right?
> 
> I think for ttm drivers it's just execbuf being exploitable. But on
> drm/i915 we've
> had the same issue with the pwrite/pread ioctls, so a simple
> glBufferData(glMap) kind of recursion from gl clients blew the kernel
> to pieces ...

And the only answer you folks came up with is set_need_resched() and
yield()? Oh well....

Thanks,

	tglx
