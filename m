Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaJ0NPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:15:53 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:59819 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaJ0NPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:15:52 -0400
Date: Mon, 27 Oct 2014 09:15:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] workqueue: add wq_unbound_online_cpumask
Message-ID: <20141027131548.GD4436@htj.dyndns.org>
References: <1412740423-20782-1-git-send-email-laijs@cn.fujitsu.com>
 <1412740423-20782-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412740423-20782-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 11:53:31AM +0800, Lai Jiangshan wrote:
> Current wq_calc_node_cpumask() is complicated by cpumask_of_node(node) whose
> value need to be revised before using and the "revising" needs @cpu_going_down
> which makes more complicated.
> 
> This patch introduces wq_unbound_online_cpumask which is updated before
> wq_update_unbound_numa() in the cpu-hotplug callbacks and wq_calc_node_cpumask()
> can use it instead of cpumask_of_node(node). Thus wq_calc_node_cpumask()
> becomes much simpler and @cpu_going_down is gone.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |   42 ++++++++++++++++++++----------------------
>  1 files changed, 20 insertions(+), 22 deletions(-)

"much simpler" seems a bit overblown for 2 LOC reduction.

> +/* PL: online cpumask for all unbound wqs */
> +static struct cpumask wq_unbound_online_cpumask;

And now someone who's reading the code has to wonder "why is wq
maintaining a separate copy of cpumask?" and from the code itself it
isn't clear at all.  I don't necessarily dislike the patch and it does
make the code a bit simpler but at the cost of higher obscurity.
You'll at least need to add more comments explaining why the separate
cpumask is necessary and how it's used.  If there are more
simplifications which can build atop, it'd be fine; otherwise, this is
firmly in the 'meh...' territory.

Thanks.

-- 
tejun
