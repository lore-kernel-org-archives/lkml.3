Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbbANQSC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:18:02 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:65154 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbbANQRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:17:50 -0500
Date: Wed, 14 Jan 2015 17:17:47 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Greg Thelen <gthelen@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] mm: memcontrol: default hierarchy interface for
 memory
Message-ID: <20150114161747.GH4706@dhcp22.suse.cz>
References: <1420776904-8559-1-git-send-email-hannes@cmpxchg.org>
 <1420776904-8559-2-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420776904-8559-2-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have overlooked the `none' setting...

On Thu 08-01-15 23:15:04, Johannes Weiner wrote:
[...]
> +static int memory_low_show(struct seq_file *m, void *v)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
> +	unsigned long low = ACCESS_ONCE(memcg->low);
> +
> +	if (low == 0)
> +		seq_printf(m, "none\n");
> +	else
> +		seq_printf(m, "%llu\n", (u64)low * PAGE_SIZE);
> +
> +	return 0;
> +}

This is really confusing. What if somebody wants to protect a group
from being reclaimed? One possible and natural way would by copying
memory.max value but then `none' means something else completely.

Besides that why to call 0, which has a clear meaning, any other name?

Now that I think about the naming `none' doesn't sound that great for
max resp. high either. If for nothing else then for the above copy
example (who knows what shows up later). Sure, a huge number is bad
as well for reasons you have mentioned in other email. `resource_max'
sounds like a better fit to me. But I am lame at naming.
-- 
Michal Hocko
SUSE Labs
