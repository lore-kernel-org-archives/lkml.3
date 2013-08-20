Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab3HTM1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:27:33 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:47087 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3HTM1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:27:31 -0400
Date: Tue, 20 Aug 2013 08:27:27 -0400
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>
Subject: Re: [RFC PATCH] freezer: allow killing of frozen tasks
Message-ID: <20130820122727.GC3926@htj.dyndns.org>
References: <5917186.DMyAa9ofOj@amdc1032>
 <37238430.gCktWD5jr4@vostro.rjw.lan>
 <20130820122200.GB3926@htj.dyndns.org>
 <7346644.tueXegsfXu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7346644.tueXegsfXu@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 02:34:14PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, August 20, 2013 08:22:00 AM Tejun Heo wrote:
> > On Tue, Aug 20, 2013 at 02:30:18PM +0200, Rafael J. Wysocki wrote:
> > > > So, I don't think we can simply turn TASK_UNITERRUPTIBLE to
> > > > TASK_KILLABLE at this point.  We really need to strictly define where
> > > > a task can freeze before being able to do anything like this.
> > > 
> > > But we could do that for user space tasks I suppose?
> > 
> > Even for userland tasks, we don't know where the task is stuck at.  I
> > think there are enough freeze points in the kernel which are in the
> > middle of something which can be used by userland tasks excuting some
> > syscall.  We need to collect all those sites into well defined trap
> > points before doing this.
> 
> OK, thanks!

I scanned through try_to_freeze() users and it seems like we don't
have that many which can be hit by userland tasks.  I think it should
be doable to audit all the users, remove the ones which can be invoked
by userland and make try_to_freeze() whine loudly if it's running off
a userland task except from well-defined spots.  Anyways, we need to
ensure that userland task doesn't get stuck deep in the kernel before
allowing this.

Thanks.

-- 
tejun
