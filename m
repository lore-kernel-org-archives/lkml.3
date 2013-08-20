Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab3HTMXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:23:41 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51366 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab3HTMXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:23:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>
Subject: Re: [RFC PATCH] freezer: allow killing of frozen tasks
Date: Tue, 20 Aug 2013 14:34:14 +0200
Message-ID: <7346644.tueXegsfXu@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130820122200.GB3926@htj.dyndns.org>
References: <5917186.DMyAa9ofOj@amdc1032> <37238430.gCktWD5jr4@vostro.rjw.lan> <20130820122200.GB3926@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 20, 2013 08:22:00 AM Tejun Heo wrote:
> On Tue, Aug 20, 2013 at 02:30:18PM +0200, Rafael J. Wysocki wrote:
> > > So, I don't think we can simply turn TASK_UNITERRUPTIBLE to
> > > TASK_KILLABLE at this point.  We really need to strictly define where
> > > a task can freeze before being able to do anything like this.
> > 
> > But we could do that for user space tasks I suppose?
> 
> Even for userland tasks, we don't know where the task is stuck at.  I
> think there are enough freeze points in the kernel which are in the
> middle of something which can be used by userland tasks excuting some
> syscall.  We need to collect all those sites into well defined trap
> points before doing this.

OK, thanks!

