Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3G2S2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:28:42 -0400
Received: from mail-gh0-f177.google.com ([209.85.160.177]:44412 "EHLO
	mail-gh0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab3G2S2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:28:41 -0400
Date: Mon, 29 Jul 2013 14:28:35 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH v3 1/8] cgroup: convert cgroup_ida to cgroup_idr
Message-ID: <20130729182835.GD26076@mtj.dyndns.org>
References: <51F614B2.6010503@huawei.com>
 <51F614C4.7060602@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F614C4.7060602@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jul 29, 2013 at 03:07:48PM +0800, Li Zefan wrote:
> @@ -4590,6 +4599,9 @@ static void cgroup_offline_fn(struct work_struct *work)
>  	/* delete this cgroup from parent->children */
>  	list_del_rcu(&cgrp->sibling);
>  
> +	if (cgrp->id)
> +		idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
> +

Yeap, if we're gonna allow lookups, removal should happen here but can
we please add short comment explaining why that is?  Also, do we want
to clear cgrp->id?

Thanks.

-- 
tejun
