Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaI1O1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 10:27:19 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:44961 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaI1O1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 10:27:18 -0400
Date: Sun, 28 Sep 2014 10:27:14 -0400
From: Tejun Heo <tj@kernel.org>
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: schedule_delayed_work with a 0 jiffy delay
Message-ID: <20140928142714.GB3736@mtj.dyndns.org>
References: <20140926105227.01325697@jlaw-desktop.mno.stratus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140926105227.01325697@jlaw-desktop.mno.stratus.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Joe.

On Fri, Sep 26, 2014 at 10:52:27AM -0400, Joe Lawrence wrote:
...
> I was wondering if such behavior was expected on !PREEMPT kernels,
> especially after b22ce2785d97 "workqueue: cond_resched() after
> processing each work item".  In the ftraces I've observed from the RCU
> stall, cond_resched() never seems to schedule.  Under what conditions
> would it be expected to do so?

Hmmm... it should yield if there's a higher priority task scheduled.
Maybe the workqueue in question is a highpri one?

> Changing the worker function to reschedule with at least 1 jiffy avoids
> this problem -- I was just curious if a fix at that end was appropriate.

The fact that 0 delay means immediate execution is depended upon in
multiple places and changing it will break other things.  The
workqueue user itself sounds buggy to me.  Can't that be fixed?

Thanks.

-- 
tejun
