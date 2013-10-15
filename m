Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084Ab3JOPYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:24:25 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:44021 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916Ab3JOPYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:24:23 -0400
Date: Tue, 15 Oct 2013 11:18:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 03/12] cpuset: update cs->effective_{cpus,mems} when
 config changes
Message-ID: <20131015151851.GK3141@htj.dyndns.org>
References: <5257C9A1.1030404@huawei.com>
 <5257C9CC.3080806@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5257C9CC.3080806@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 05:50:04PM +0800, Li Zefan wrote:
> +	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
> +		struct cpuset *parent = parent_cs(cp);
> +		struct cpumask *new_cpus = trialcs->effective_cpus;
> +
> +		cpumask_and(new_cpus, cp->cpus_allowed,
> +			    parent->effective_cpus);

So, @trial_cs is only passed in to use its ->effective_cpus as
temporary buffer?  If allocating from inside the function isn't an
option, wouldn't it be better to pass in cpumask * instead of the
whole trial_cs and explicitly note that the argument is used as a temp
var?

...
> +	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
> +		struct cpuset *parent = parent_cs(cp);
> +		nodemask_t *new_mems = &trialcs->effective_mems;
> +
> +		nodes_and(*new_mems, cp->mems_allowed,
> +			  parent->effective_mems);

Ditto.

Thanks.

-- 
tejun
