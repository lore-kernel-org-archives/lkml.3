Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab3AXSvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:51:11 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:57250 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3AXSvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:51:09 -0500
Date: Thu, 24 Jan 2013 10:51:03 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCHSET] workqueue: remove gcwq and make worker_pool the only
 backend abstraction
Message-ID: <20130124185103.GP2373@mtj.dyndns.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
 <510138E7.4060502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510138E7.4060502@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Lai.

On Thu, Jan 24, 2013 at 09:36:39PM +0800, Lai Jiangshan wrote:
> For the whole patchset
> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thanks for reviewing it.

> The only concern: get_work_pool() may slow down __queue_work().

Yeap, I'm currently working on to optimize idr so that the fast path
basically comes down to

	if (id < FIRST_LAYER_LIMIT)
		return idr->first_layer[id];

> I think we can save the pool->id at work_struct->entry.next, It will
> simply the code a little.

Hmm... I'm not sure whether saving id somewhere else would make any
noticeable difference.  Decoding ->id probalby comes down to a couple
bit shuffling instructions.

> More aggressive, we can save the work_pool
> pointer at work_struct->entry.next, it will simply more code and
> __queue_work() will not be slowed down. (It is the user's
> responsibility not to modify work_struct if the user want to pass it
> to workqueue API later)

We probably can't store pointers to pools directly because custom
pools will need to be dynamically created and destroyed.

Thanks.

-- 
tejun
