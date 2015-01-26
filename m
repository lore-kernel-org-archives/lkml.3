Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbbAZOXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:23:03 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61655 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752517AbbAZOXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:23:00 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v3]PM/Sleep: Timer quiesce in freeze state
Date: Mon, 26 Jan 2015 15:45:43 +0100
Message-ID: <2433846.5N8KuFRAKW@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1501261513040.5526@nanos>
References: <54866625.8010406@linux.intel.com> <7916564.nnH80uMtkt@vostro.rjw.lan> <alpine.DEB.2.11.1501261513040.5526@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 26, 2015 03:15:43 PM Thomas Gleixner wrote:
> On Mon, 26 Jan 2015, Rafael J. Wysocki wrote:
> 
> > On Monday, January 26, 2015 10:40:24 AM Thomas Gleixner wrote:
> > > On Mon, 26 Jan 2015, Li, Aubrey wrote:
> > > > On 2015/1/22 18:15, Thomas Gleixner wrote:
> > > > > Can we please stop adding more crap to that notifier thing? I rather
> > > > > see that go away than being expanded.
> > > > 
> > > > Are you referring to FREEZE_PREPARE or remove all of FREEZE staff at all?
> > > > 
> > > > What's the disadvantage of adding more notifier?
> > > 
> > > clockevents_notify() is not a notifier. Its a multiplex call and I
> > > want to get rid of it and replace it with explicit functions.
> > 
> > OK, so perhaps we need to move _SUSPEND/_RESUME out of there to start with?
> > 
> > As far as I can say, clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL) and
> > clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL) are each only called from
> > one place and moreover, since they are in syscore_ops, we don't need any
> > locking around them.
> > 
> > So what about the patch below?
> 
> I'm cleaning up the whole replacement of notify. The stuff below is
> part of it.
> 
> >  
> > -	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
> > +	tick_suspend();
> > +	tick_suspend_broadcast();
> 
> That's exactly the stuff I don't want to see. Blind code
> move.

At least it's clear what the patch does. :-)

> tick_suspend_broadcast() wants to be called from tick_suspend().

OK

> Still compiling and testing a gazillion of combinations.

OK, so it looks like we need to wait with the suspend to idle changes until
this lands.

Rafael

