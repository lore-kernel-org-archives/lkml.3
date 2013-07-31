Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab3GaGIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:08:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57761 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab3GaGIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:08:34 -0400
X-IronPort-AV: E=Sophos;i="4.89,785,1367942400"; 
   d="scan'208";a="8074588"
Message-ID: <51F8AACD.1030601@cn.fujitsu.com>
Date: Wed, 31 Jul 2013 14:12:29 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, shli@kernel.org
Subject: Re: [PATCH 1/9] workqueue: mark WQ_NON_REENTRANT deprecated
References: <1375188028-11910-1-git-send-email-tj@kernel.org> <1375188028-11910-2-git-send-email-tj@kernel.org>
In-Reply-To: <1375188028-11910-2-git-send-email-tj@kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/31 14:06:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/31 14:06:19,
	Serialize complete at 2013/07/31 14:06:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 08:40 PM, Tejun Heo wrote:
> dbf2576e37 ("workqueue: make all workqueues non-reentrant") made
> WQ_NON_REENTRANT no-op but the following patches didn't remove the
> flag or update the documentation.  Let's mark the flag deprecated and
> update the documentation accordingly.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>

> ---
>  Documentation/workqueue.txt | 18 ++++++------------
>  include/linux/workqueue.h   |  7 ++++++-
>  2 files changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/workqueue.txt b/Documentation/workqueue.txt
> index a6ab4b6..67113f6 100644
> --- a/Documentation/workqueue.txt
> +++ b/Documentation/workqueue.txt
> @@ -100,8 +100,8 @@ Subsystems and drivers can create and queue work items through special
>  workqueue API functions as they see fit. They can influence some
>  aspects of the way the work items are executed by setting flags on the
>  workqueue they are putting the work item on. These flags include
> -things like CPU locality, reentrancy, concurrency limits, priority and
> -more.  To get a detailed overview refer to the API description of
> +things like CPU locality, concurrency limits, priority and more.  To
> +get a detailed overview refer to the API description of
>  alloc_workqueue() below.
>  
>  When a work item is queued to a workqueue, the target gcwq and
> @@ -166,16 +166,6 @@ resources, scheduled and executed.
>  
>  @flags:
>  
> -  WQ_NON_REENTRANT
> -
> -	By default, a wq guarantees non-reentrance only on the same
> -	CPU.  A work item may not be executed concurrently on the same
> -	CPU by multiple workers but is allowed to be executed
> -	concurrently on multiple CPUs.  This flag makes sure
> -	non-reentrance is enforced across all CPUs.  Work items queued
> -	to a non-reentrant wq are guaranteed to be executed by at most
> -	one worker system-wide at any given time.
> -
>    WQ_UNBOUND
>  
>  	Work items queued to an unbound wq are served by a special
> @@ -233,6 +223,10 @@ resources, scheduled and executed.
>  
>  	This flag is meaningless for unbound wq.
>  
> +Note that the flag WQ_NON_REENTRANT no longer exists as all workqueues
> +are now non-reentrant - any work item is guaranteed to be executed by
> +at most one worker system-wide at any given time.
> +
>  @max_active:
>  
>  @max_active determines the maximum number of execution contexts per
> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index a0ed78a..594521b 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -295,7 +295,12 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
>   * Documentation/workqueue.txt.
>   */
>  enum {
> -	WQ_NON_REENTRANT	= 1 << 0, /* guarantee non-reentrance */
> +	/*
> +	 * All wqs are now non-reentrant making the following flag
> +	 * meaningless.  Will be removed.
> +	 */
> +	WQ_NON_REENTRANT	= 1 << 0, /* DEPRECATED */
> +
>  	WQ_UNBOUND		= 1 << 1, /* not bound to any cpu */
>  	WQ_FREEZABLE		= 1 << 2, /* freeze during suspend */
>  	WQ_MEM_RECLAIM		= 1 << 3, /* may be used for memory reclaim */

