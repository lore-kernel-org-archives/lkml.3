Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593AbaFSQZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:25:22 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:35622 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933445AbaFSQZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:25:17 -0400
Date: Thu, 19 Jun 2014 12:25:13 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: remove the empty check in too_many_workers()
Message-ID: <20140619162513.GJ26904@htj.dyndns.org>
References: <1401780727-12161-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401780727-12161-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 03:32:07PM +0800, Lai Jiangshan wrote:
> The commit ea1abd6197d5 ("workqueue: reimplement idle worker rebinding")
> used a trick which simply removes all to-be-bound idle workers from the
> idle list and lets them add themselves back after completing rebinding.
> 
> And this trick caused the @worker_pool->nr_idle may deviate than the actual
> number of idle workers on @worker_pool->idle_list.  More specifically,
> nr_idle may be non-zero while ->idle_list is empty.  All users of
> ->nr_idle and ->idle_list are audited.  The only affected one is
> too_many_workers() which is updated to check %false if ->idle_list is
> empty regardless of ->nr_idle.
> 
> The commit/trick was complicated due to it just tried to simplify an even
> more complicated problem (workers had to rebind itself). But the commit
> a9ab775bcadf ("workqueue: directly restore CPU affinity of workers
> from CPU_ONLINE") fixed all these problems and the mentioned trick was
> useless and is gone.
> 
> So, now the @worker_pool->nr_idle is exactly the actual number of workers
> on @worker_pool->idle_list. too_many_workers() should recover as it was
> before the trick. So we remove the empty check.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to wq/for-3.17.

Thanks.

-- 
tejun
