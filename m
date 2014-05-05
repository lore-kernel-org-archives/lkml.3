Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbaEEOgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:36:18 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:45167 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932794AbaEEOgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:36:16 -0400
Date: Mon, 5 May 2014 10:36:13 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] workqueue: destroy worker directly in the idle
 timeout handler
Message-ID: <20140505143613.GD11231@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
 <1398571754-12443-5-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398571754-12443-5-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 12:08:59PM +0800, Lai Jiangshan wrote:
> Since kthread_stop() is removed from destroy_worker(),
> destroy_worker() doesn't need to sleep.
> Since "unbind the worker" is moved out from destroy_worker(),
> destroy_worker() doesn't require manager_mutex.
> 
> So destroy_worker() can be directly called in the idle timeout
> handler, it helps us remove POOL_MANAGE_WORKERS and
> maybe_destroy_worker() and simplify the manage_workers()
> 
> After POOL_MANAGE_WORKERS is removed, worker_thread() doesn't
> need to test whether it needs to manage after processed works.
> So we can remove this test branch.

Ah, so, you can take out workers directly from idle timer.  Yeah,
that's nice.  I'm not a big fan of the wait_queue usage in the
previous patch tho.  Can we use a completion instead?

Thanks.

-- 
tejun
