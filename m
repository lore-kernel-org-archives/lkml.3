Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275Ab3JOPZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:25:44 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:63385 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875Ab3JOPZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:25:42 -0400
Date: Tue, 15 Oct 2013 11:25:38 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 05/12] cpuset: use effective cpumask to build sched
 domains
Message-ID: <20131015152538.GL3141@htj.dyndns.org>
References: <5257C9A1.1030404@huawei.com>
 <5257C9EE.9080902@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5257C9EE.9080902@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 05:50:38PM +0800, Li Zefan wrote:
> @@ -930,10 +931,21 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpuset *trialcs,
>  
>  		update_tasks_cpumask(cp, heap);
>  
> +		/*
> +		 * If the effective cpumask of any non-empty cpuset is
> +		 * changed, we need to rebuild sched domains.
> +		 */
> +		if (!cpumask_empty(cp->cpus_allowed) &&
> +		    is_sched_load_balance(cp))
> +			need_rebuild_sched_domains = true;
> +

Can you please explain *why* this change is being made in the patch
description?  The patch description doesn't give me anything and the
comment explain "what" but not why it's moved from update_cpumask()
into this function with an extra condition.

Thanks.

-- 
tejun
