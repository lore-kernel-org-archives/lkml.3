Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaEVNsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:48:04 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:44496 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbaEVNsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:48:01 -0400
Date: Thu, 22 May 2014 09:47:58 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: remove the unneeded cpu_relax() in
 __queue_work()
Message-ID: <20140522134758.GA5065@htj.dyndns.org>
References: <1400748257-14165-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400748257-14165-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 04:44:16PM +0800, Lai Jiangshan wrote:
> When pwq->refcnt == 0, the retrying is guaranteed to make forward-progress.
> The comment above the code explains it well:
> 
> 	/*
> 	 * pwq is determined and locked.  For unbound pools, we could have
> 	 * raced with pwq release and it could already be dead.  If its
> 	 * refcnt is zero, repeat pwq selection.  Note that pwqs never die
> 	 * without another pwq replacing it in the numa_pwq_tbl or while
> 	 * work items are executing on it, so the retrying is guaranteed to
> 	 * make forward-progress.
> 	 */
> 
> It means the cpu_relax() here is useless and sometimes misleading,
> it should retry directly and make some progress rather than waste time.

cpu_relax() doesn't have much to do with guaranteeing forward
progress.  It's about giving a breather during busy wait so that the
waiting cpu doesn't busy loop claiming the same cache lines over and
over ultimately delaying the event being waited on.  If you're doing a
busy wait, you better use cpu_relax().

Thanks.

-- 
tejun
