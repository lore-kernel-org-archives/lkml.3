Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaEGUW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:22:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:50340 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaEGUWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:22:24 -0400
Date: Wed, 7 May 2014 22:22:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <mgalbraith@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] CPU hotplug: Slow down hotplug operations
In-Reply-To: <20140507130655.9f7c46de8cb39726079458fb@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1405072214420.6261@ionos.tec.linutronix.de>
References: <1399492661-891-1-git-send-email-bp@alien8.de> <20140507130655.9f7c46de8cb39726079458fb@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, Andrew Morton wrote:
> On Wed,  7 May 2014 21:57:41 +0200 Borislav Petkov <bp@alien8.de> wrote:
> 
> > We have all those eager tester dudes which scratch up a dirty script to
> > pound on CPU hotplug senselessly and then report bugs they've managed to
> > trigger.
> > 
> > Well, first of all, most, if not all, bugs they trigger are CPU hotplug
> > related anyway. But we know hotplug is full of duct tape and brown
> > paper bags. So we end up clearly wasting too much time dealing with a
> > mechanism we know it is b0rked in the first place.
> > 
> > Oh, and I would understand if that pounding were close to some real
> > usage patterns but I've yet to receive a justification for toggling
> > cores on- and offline senselessly.
> > 
> > In any case, before this gets rewritten properly (I'm being told we
> > might get lucky after all) let's slow down hotplugging on purpose and
> > thus make it uninteresting, as a temporary brown paper bag solution
> > until the real thing gets done.
> > 
> > This way we'll save us a lot of time and efforts in chasing the wrong
> > bugs.
> 
> Well, I only yesterday merged Srivatsa's `CPU hotplug, stop-machine:
> plug race-window that leads to "IPI-to-offline-CPU"' bugfix.  That bug
> presumably wouldn't have been fixed if this patch was in place.

True.

OTOH, if people would have spent the same amount of time to rewrite
the hotplug mess, we would have a way bigger benefit. But no, we
prefer to add more layers of duct tape and bandaid hackery to it. 

I tried a redesign and run out of cycles, but the patches are out
there and none of the folks who promised to complete them ever
delivered. If nothing fundamental changes, I'm going to spend some
serious time on it in the next couple of month.

Thanks,

	tglx




 
