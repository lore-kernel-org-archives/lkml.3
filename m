Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab3BESxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:53:55 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:58895 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab3BESxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:53:54 -0500
Date: Tue, 5 Feb 2013 10:53:49 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/13] workqueue: fix work_busy()
Message-ID: <20130205185349.GF4276@mtj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-3-git-send-email-laijs@cn.fujitsu.com>
 <20130204195458.GA27963@mtj.dyndns.org>
 <5110F5DE.6030407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5110F5DE.6030407@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 05, 2013 at 08:06:54PM +0800, Lai Jiangshan wrote:
> >>@@ -3453,15 +3451,13 @@ unsigned int work_busy(struct work_struct *work)
> >>  {
> >>  	struct worker_pool *pool = get_work_pool(work);
> >>  	unsigned long flags;
> >>-	unsigned int ret = 0;
> >>+	unsigned int ret = work_pending(work) ? WORK_BUSY_PENDING : 0;
> >
> >I'd prefer this as a if() statement.
> >
> >>  	if (!pool)
> >>-		return 0;
> >>+		return ret;
> >
> >I'm a bit confused.  When can we be pending w/o pool?
> >
> 
> grab the pending bits <==time==> really queued
> 			^
> 		this patch considers the work is busy in this time

Given the advisory nature of the function, why do we care?  Is it
needed for later patches?

Thanks.

-- 
tejun
