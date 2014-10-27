Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaJ0NlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:41:25 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:58085 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbaJ0NlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:41:24 -0400
Date: Mon, 27 Oct 2014 09:41:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] workqueue: remove get_online_cpus() from
 apply_workqueue_attrs()
Message-ID: <20141027134120.GF4436@htj.dyndns.org>
References: <1412740423-20782-1-git-send-email-laijs@cn.fujitsu.com>
 <1412740423-20782-4-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412740423-20782-4-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 11:53:33AM +0800, Lai Jiangshan wrote:
> There are two aims for get_online_cpus():
>   1) Protects cpumask_of_node(node). (CPUs should stay stable)
>   2) Protects the pwq-allocation and installation
> 
> But both aims are settled by other methods in previous patches:
> cpumask_of_node(node) is replaced by wq_unbound_online_cpumask, and
> the pwq-allocation and installation are changed to be protected by
> wq_pool_mutex.  Now the get_online_cpus() is no reason to exist,
> remove it!
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Well, this is very marginal and we want to add comments explaining why
this is safe, but yeah I guess it's an improvement.  Can you please
add comments explaining what states are depended upon and that they
are all protected by pool mutex?

Thanks.

-- 
tejun
