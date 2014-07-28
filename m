Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750980AbaG1SUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:20:45 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:46644 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaG1SUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:20:42 -0400
Date: Mon, 28 Jul 2014 14:20:38 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: Re: [PATCH] kthread_work: add cancel_kthread_work[_sync]()
Message-ID: <20140728182038.GF7462@htj.dyndns.org>
References: <1406347444-4045-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406347444-4045-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 12:04:01PM +0800, Lai Jiangshan wrote:
> When an object or a subsystem quits, we need to destroy the kthread_work
> which is used by the object or the subsystem.  We used to use
> flush_kthread_work().  But flush_kthread_work() has not any guarantee
> about the suspension of the work, this duty is pushed to the users.
> 
> So we introduce the cancel_kthread_work_sync() with a strict guarantee
> like cancel_work_sync() (workqueue).  We also introduce cancel_kthread_work()
> which can be used by users on some conditions.  And it is required for
> making the implementation of the cancel_kthread_work_sync() simpler.
> kthread_flush_work_fn() owns the running state of the kthread_worker
> and calls cancel_kthread_work() to cancel the possible requeued work.
> 
> Both cancel_kthread_work_sync() and cancel_kthread_work() share the
> code of flush_kthread_work() which also make the implementation simpler.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  include/linux/kthread.h |    2 +
>  kernel/kthread.c        |   78 ++++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 66 insertions(+), 14 deletions(-)

We don't have any user.  Let's not implement features which aren't
used just for completeness.  If you can spot and convert users, please
be my guest.

Thanks.

-- 
tejun
