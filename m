Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab3BSKql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:46:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45567 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab3BSKqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:46:40 -0500
Date: Tue, 19 Feb 2013 11:46:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Li, Fei" <fei.li@intel.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Goswin von Brederlow <goswin-v-b@web.de>,
        "Brown, Len" <len.brown@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Wang, Biao" <biao.wang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: Getting rid of freezer for suspend [was Re: [fuse-devel] [PATCH]
 fuse: make fuse daemon frozen along with kernel threads]
Message-ID: <20130219104633.GA23279@xo-6d-61-c0.localdomain>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <6332427.iqPUMjtDaQ@vostro.rjw.lan>
 <BEC9F67575FA1E429CA7CF5AE9BE3634400F30@SHSMSX102.ccr.corp.intel.com>
 <3321530.AgvEeduuPx@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3321530.AgvEeduuPx@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > Well, I suppose that information is available to user space.
> > > > >
> > > > > Do we need an interface for a process to mark itself as PF_FREEZE_LATE or
> > > > > do we need an interface for one process to mark another process as
> > > > > PF_FREEZE_LATE, or both?
> > > >
> > > > As a first step marking self with PF_FREEZE_LATE and inheriting this
> > > > flag across fork/clone would work for most cases, I think.
> > > 
> > > OK, so we can just have a switch for that in /proc I suppose.
> > 
> > Thanks for feedback and suggestion.
> > 
> > We have ever tried similar idea, expose interface /sys/power/pm_freeze_daemon,
> > userspace tasks write 1 to this attribute to make itself to be frozen at the same time
> > with kernel tasks, and it worked in our experiment.
> > 
> > Do you think it's suitable and enough to use such attribute /sys/power/pm_freeze_late, 
> > or other more suitable place under /proc suggested?
> 
> I think it should be inder /proc, because that's where controls related to
> process behavior are located.  E.g. /proc/PID/freeze_late or something like
> that.

freeze_priority?

I _hope_ we will not need more than three priorities, (user, fused, kernel), but 
I hoped not no need more than two before, so...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
