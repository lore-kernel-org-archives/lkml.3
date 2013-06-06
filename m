Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3FFXQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 19:16:13 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:41522 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3FFXQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 19:16:11 -0400
Date: Thu, 6 Jun 2013 16:16:07 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org,
        Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.cz>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH v7 05/11] cpuacct: don't actually do anything.
Message-ID: <20130606231607.GO5045@htj.dyndns.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
 <1369825402-31046-6-git-send-email-glommer@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369825402-31046-6-git-send-email-glommer@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

I think the patch title / description are a bit confusing.  This is
about pcpuacct stats provided by cpu controller, right?

> +#ifdef CONFIG_SCHEDSTATS
> +#ifdef CONFIG_FAIR_GROUP_SCHED
...
>  #else
...
> +#endif
> +#ifdef CONFIG_RT_GROUP_SCHED
...
> +#else
...
>  #endif
...
> +#else
> +#endif

This is getting rather messy.  Maybe CONFIG_CGROUP_SCHED should just
select CONFIG_SCHEDSTATS?

Thanks.

-- 
tejun
