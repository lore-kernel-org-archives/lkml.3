Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351AbaGITSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:18:43 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:39465 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbaGITSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:18:39 -0400
Date: Wed, 9 Jul 2014 15:18:36 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v3 05/12] cpuset: use effective cpumask to build sched
 domains
Message-ID: <20140709191836.GA21090@htj.dyndns.org>
References: <53BD0174.4060002@huawei.com>
 <53BD01B6.403@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD01B6.403@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 04:47:50PM +0800, Li Zefan wrote:
> +		/*
> +		 * If the effective cpumask of any non-empty cpuset is changed,
> +		 * we need to rebuild sched domains.
> +		 */
> +		if (!cpumask_empty(cp->cpus_allowed) &&
> +		    is_sched_load_balance(cp))
> +			need_rebuild_sched_domains = true;

Hmmm... is this because if cpus_allowed is empty, the effective always
equals the parent?  If so, let's update the comment so that it
explains why the code is like that.  The current comment just explains
what it does which isn't very helpful.

Thanks.

-- 
tejun
