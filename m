Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab3HTMSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:18:25 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:49886 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3HTMSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:18:23 -0400
Date: Tue, 20 Aug 2013 08:18:19 -0400
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>
Subject: Re: [RFC PATCH] freezer: allow killing of frozen tasks
Message-ID: <20130820121819.GA3926@htj.dyndns.org>
References: <5917186.DMyAa9ofOj@amdc1032>
 <4596920.E6jI568rc1@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4596920.E6jI568rc1@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 20, 2013 at 02:23:32PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, August 20, 2013 01:20:03 PM Bartlomiej Zolnierkiewicz wrote:
> > Change __refrigerator() to allow SIGKILL signal handling during
> > the frozen state (by setting task to a TASK_KILLABLE state instead
> > of TASK_UNINTERRUPTIBLE one before entering sleep) and make tasks
> > leave __refrigerator() upon receiving such signal.
> > 
> > These changes allow frozen tasks to be killed immediately without
> > the need to thaw them first.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Well, it doesn't sound like an entirely bad idea to me, but I'd like to know
> what Colin and Tejun (CCed now) think about it.

The problem is that we really don't know where each task is frozen in
the kernel so don't know what happens after the task leaves the
freezer is safe whether it's dying or not.  We don't have any rules
restricting where a freeze point should be and a task may do any
operation between freezer and actual exit.

So, I don't think we can simply turn TASK_UNITERRUPTIBLE to
TASK_KILLABLE at this point.  We really need to strictly define where
a task can freeze before being able to do anything like this.

Thanks.

-- 
tejun
