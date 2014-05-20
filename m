Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaETPAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:00:08 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:36733 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbaETPAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:00:06 -0400
Date: Tue, 20 May 2014 11:00:01 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 00/10] workqueue: async worker destruction and worker
 attaching/detaching
Message-ID: <20140520150001.GE2804@htj.dyndns.org>
References: <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
 <1400579204-3647-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400579204-3647-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 05:46:26PM +0800, Lai Jiangshan wrote:
> Patch1-4: async worker destruction
> 
> Patch2 reduces the review burden. It will be easier to review the whole
> patchset if we know destroy_worker() is forced to destroy idle workers only.
> 
> Patch5-10: worker attaching/detaching and simplify the workers management
> 
> The code which attaches a worker to the pool and detaches a worker from the pool
> is unfolded in create_worker()/destroy_worker().
> The patchset moves this attaching/detaching code out and wraps them.
> 
> patch3-4 moves the detaching code out from destroy_worker(), and make
> manger_mutex only protects the detaching code only rather than
> protects the whole worker-destruction path.
> 
> patch5-7 makes manger_mutex only protects the attaching code rather than the
> whole worker-creation path.
> 
> patch8: rename manger_mutex to attach_mutex
> patch9-10: moves the attaching code out from create_worker() and use it for
> rescuer.
> 
> 
> Lai Jiangshan (10):
>   workqueue: use manager lock only to protect worker_idr
>   workqueue: destroy_worker() should destroy idle workers only
>   workqueue: async worker destruction
>   workqueue: destroy worker directly in the idle timeout handler
>   workqueue: separate iteration role from worker_idr
>   workqueue: convert worker_idr to worker_ida
>   workqueue: narrow the protection range of manager_mutex
>   workqueue: rename manager_mutex to attach_mutex
>   workqueue: separate pool-attaching code out from create_worker()
>   workqueue: use generic attach/detach routine for rescuers

Applied to wq/for-3.16 with comment and description updates.

Thanks.

-- 
tejun
