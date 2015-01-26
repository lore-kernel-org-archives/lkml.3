Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbbAZOQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:16:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:47185 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbbAZOQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:16:09 -0500
Date: Mon, 26 Jan 2015 15:15:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v3]PM/Sleep: Timer quiesce in freeze state
In-Reply-To: <7916564.nnH80uMtkt@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.11.1501261513040.5526@nanos>
References: <54866625.8010406@linux.intel.com> <54C5FE6A.9010300@linux.intel.com> <alpine.DEB.2.11.1501260946390.5526@nanos> <7916564.nnH80uMtkt@vostro.rjw.lan>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015, Rafael J. Wysocki wrote:

> On Monday, January 26, 2015 10:40:24 AM Thomas Gleixner wrote:
> > On Mon, 26 Jan 2015, Li, Aubrey wrote:
> > > On 2015/1/22 18:15, Thomas Gleixner wrote:
> > > > Can we please stop adding more crap to that notifier thing? I rather
> > > > see that go away than being expanded.
> > > 
> > > Are you referring to FREEZE_PREPARE or remove all of FREEZE staff at all?
> > > 
> > > What's the disadvantage of adding more notifier?
> > 
> > clockevents_notify() is not a notifier. Its a multiplex call and I
> > want to get rid of it and replace it with explicit functions.
> 
> OK, so perhaps we need to move _SUSPEND/_RESUME out of there to start with?
> 
> As far as I can say, clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL) and
> clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL) are each only called from
> one place and moreover, since they are in syscore_ops, we don't need any
> locking around them.
> 
> So what about the patch below?

I'm cleaning up the whole replacement of notify. The stuff below is
part of it.

>  
> -	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
> +	tick_suspend();
> +	tick_suspend_broadcast();

That's exactly the stuff I don't want to see. Blind code
move. tick_suspend_broadcast() wants to be called from tick_suspend().

Still compiling and testing a gazillion of combinations.

Thanks,

	tglx
