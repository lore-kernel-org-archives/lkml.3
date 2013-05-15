Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115Ab3EOVLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:11:22 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:57768 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689Ab3EOVLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:11:20 -0400
Date: Wed, 15 May 2013 14:11:16 -0700
From: Tejun Heo <tj@kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/workqueue.c: kfree issue, need check flag
 'WQ_UNBOUND' when processing failure.
Message-ID: <20130515211116.GD26222@htj.dyndns.org>
References: <519236E0.4020301@asianux.com>
 <20130514152046.GC6795@mtj.dyndns.org>
 <5192E62C.5090107@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5192E62C.5090107@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 09:34:36AM +0800, Chen Gang wrote:
> On 05/14/2013 11:20 PM, Tejun Heo wrote:
> > On Tue, May 14, 2013 at 09:06:40PM +0800, Chen Gang wrote:
> >>  err_destroy:
> >>  	destroy_workqueue(wq);
> >> +	if (flags & WQ_UNBOUND) {
> >> +err_free_wq:
> >> +		free_workqueue_attrs(wq->unbound_attrs);
> >> +		kfree(wq);
> >> +	}
> > 
> > Doesn't the above make the code free wq twice on after err_destroy?
> > 
> 
> Oh, it is my fault. I did not see the put_pwq_unlocked() in details,
> next I should read the code carefully.

We're still leaking unbound_attrs in the failure path, right?  We can
probably just add unconditional free_workqueue_attrs() in err_free_wq?

Thanks.

-- 
tejun
