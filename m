Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab3E0IAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 04:00:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36609 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab3E0IAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 04:00:42 -0400
Date: Mon, 27 May 2013 10:00:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH v3 2/3] mutex: add support for wound/wait style locks, v3
Message-ID: <20130527080019.GD2781@laptop>
References: <20130428165914.17075.57751.stgit@patser>
 <20130428170407.17075.80082.stgit@patser>
 <20130430191422.GA5763@phenom.ffwll.local>
 <519CA976.9000109@canonical.com>
 <20130522161831.GQ18810@twins.programming.kicks-ass.net>
 <519CFF56.90600@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519CFF56.90600@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 07:24:38PM +0200, Maarten Lankhorst wrote:
> >> +- Functions to only acquire a single w/w mutex, which results in the exact same
> >> +  semantics as a normal mutex. These functions have the _single postfix.
> > This is missing rationale.

> trylock_single is useful when iterating over a list, and you want to evict a bo, but only the first one that can be acquired.
> lock_single is useful when only a single bo needs to be acquired, for example to lock a buffer during mmap.

OK, so given that its still early, monday and I haven't actually spend
much time thinking on this; would it be possible to make:
ww_mutex_lock(.ctx=NULL) act like ww_mutex_lock_single()?

The idea is that if we don't provide a ctx, we'll get a different
lockdep annotation; mutex_lock() vs mutex_lock_nest_lock(). So if we
then go and make a mistake, lockdep should warn us.

Would that work or should I stock up on morning juice?
