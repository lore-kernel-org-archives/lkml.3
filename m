Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbaC0OtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 10:49:04 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:44133 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbaC0OtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 10:49:02 -0400
Date: Thu, 27 Mar 2014 10:48:54 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: add __WQ_FREEZING and remove POOL_FREEZING
Message-ID: <20140327144854.GA18503@htj.dyndns.org>
References: <20130421012925.GA19097@mtj.dyndns.org>
 <1395741364-19489-1-git-send-email-laijs@cn.fujitsu.com>
 <533414C7.1050607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533414C7.1050607@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 08:08:39PM +0800, Lai Jiangshan wrote:
> On 03/25/2014 05:56 PM, Lai Jiangshan wrote:
> > freezing is nothing related to pools, but POOL_FREEZING adds a connection,
> > and causes freeze_workqueues_begin() and thaw_workqueues() complicated.
> > 
> > Since freezing is workqueue instance attribute, so we introduce __WQ_FREEZING
> > to wq->flags instead and remove POOL_FREEZING.
> > 
> > we set __WQ_FREEZING only when freezable(to simplify pwq_adjust_max_active()),
> > make freeze_workqueues_begin() and thaw_workqueues() fast skip non-freezable wq.
> > 
> > Changed from previous patches(requested by tj):
> > 	1) added the WARN_ON_ONCE() back
> > 	2) merged the two patches as one
> 
> Ping.
> 
> Hi, Tejun
> 
> You had reviewed this patch several rounds.
> I had applied all your requests(the last two is listed above) in your comments.
> 
> I'm deeply sorry for responding so late.

No worries but I think it's a bit too late in the devel cycle to apply
it to for-3.15.  Let's do it in the next cycle.  Can you please ping
me when v3.16-rc1 drops?

Thanks.

-- 
tejun
