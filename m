Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab3HUOS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:18:57 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:63012 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab3HUOSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:18:55 -0400
Date: Wed, 21 Aug 2013 10:18:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 10/11] cpuset: allow writing offlined masks to
 cpuset.cpus/mems
Message-ID: <20130821141851.GJ19286@mtj.dyndns.org>
References: <52148F52.0@huawei.com>
 <52148FF1.5060503@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52148FF1.5060503@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 21, 2013 at 06:01:21PM +0800, Li Zefan wrote:
> -		if (!cpumask_subset(trialcs->cpus_allowed, cpu_active_mask))
> +		if (!cpumask_subset(trialcs->cpus_allowed,
> +				    top_cpuset.cpus_allowed))

Hmmm... top_cpuset.cpus_allowed is filled using cpumask_setall(),
which may include more bits than cpu_possible_mask, which is kinda
weird.  We probably wanna initialize it with cpu_possible_mask and
also maybe using cpu_possible_mask in the above would be clearer?

Also, shouldn't this be dependent upon sane_behavior?

Thanks.

-- 
tejun
