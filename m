Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaJETrx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 15:47:53 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:42004 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaJETrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 15:47:51 -0400
Date: Sun, 5 Oct 2014 15:47:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, jiri@resnulli.us,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] workqueue: add quiescent state between work items
Message-ID: <20141005194748.GG8549@htj.dyndns.org>
References: <1412529862-17954-1-git-send-email-joe.lawrence@stratus.com>
 <1412529862-17954-2-git-send-email-joe.lawrence@stratus.com>
 <20141005192119.GE8549@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141005192119.GE8549@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2014 at 03:21:19PM -0400, Tejun Heo wrote:
> On Sun, Oct 05, 2014 at 01:24:21PM -0400, Joe Lawrence wrote:
> > Similar to the stop_machine deadlock scenario on !PREEMPT kernels
> > addressed in b22ce2785d97 "workqueue: cond_resched() after processing
> > each work item", kworker threads requeueing back-to-back with zero jiffy
> > delay can stall RCU. The cond_resched call introduced in that fix will
> > yield only iff there are other higher priority tasks to run, so force a
> > quiescent RCU state between work items.
> > 
> > Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> > Link: https://lkml.kernel.org/r/20140926105227.01325697@jlaw-desktop.mno.stratus.com
> > Link: https://lkml.kernel.org/r/20140929115445.40221d8e@jlaw-desktop.mno.stratus.com
> > Fixes: b22ce2785d97 ("workqueue: cond_resched() after processing each work item")
> > Cc: <stable@vger.kernel.org>
> 
> Applied to wq/for-3.17-fixes.  If 3.17 comes out before this gets
> merged, I'll send it as for-3.18.

Oops, the rcu calls aren't in mainline yet.  I think it'd be best to
route these through the RCU tree.  Paul, can you please route these
two patches?

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
