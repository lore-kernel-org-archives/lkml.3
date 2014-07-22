Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbaGVPdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:33:32 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:61766 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbaGVPdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:33:31 -0400
Date: Tue, 22 Jul 2014 11:33:27 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: remove the stale comment in
 pwq_unbound_release_workfn()
Message-ID: <20140722153327.GG13851@htj.dyndns.org>
References: <1406005467-12106-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406005467-12106-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 01:04:27PM +0800, Lai Jiangshan wrote:
> In 75ccf5950f82 ("workqueue: prepare flush_workqueue() for dynamic
> creation and destrucion of unbound pool_workqueues"), a comment
> about the synchronization for the pwq in pwq_unbound_release_workfn()
> was added. The comment clained the flush_mutex was isn't strictly
> necessary, it was correct in that time, due to the pwq was protected
> by workqueue_lock.
> 
> But it is incorrect now since the wq->flush_mutex was renamed to
> wq->mutex and workqueue_lock was removed, the wq->mutex is strictly
> needed. But the comment was miss-updated when the synchronization
> was changed.
> 
> This patch removes the incorrect comments directly, and it doesn't
> add any new comment to explain why wq->mutex is needed here,
> which is definitely obvious and wq->pwqs_node has "WQ" notation
> in its definition which is better comment.
> 
> The old commit mentioned above also introduced a comment in link_pwq()
> about the synchronization. This comment is also removed in this patch
> since the whole link_pwq() is proteced by wq->mutex.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to wq/for-3.17.

Thanks.

-- 
tejun
