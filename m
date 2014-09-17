Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbaIQVhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:37:42 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:41040 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907AbaIQVhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:37:41 -0400
Date: Thu, 18 Sep 2014 06:37:34 +0900
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] cgroup: reuse css->destroy_work for release agent
Message-ID: <20140917213734.GD15795@mtj.dyndns.org>
References: <54195FE1.9030607@huawei.com>
 <5419606D.4070707@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5419606D.4070707@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 06:20:29PM +0800, Li Zefan wrote:
> Currently we use a global work to schedule release agent on removable
> cgroups. We can change to reuse css->destroy_work to do this, which
> saves a few lines of code.
> 
> Signed-off-by: Zefan Li <lizefan@huawei.com>
...
> @@ -1587,6 +1581,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
>  		INIT_LIST_HEAD(&cgrp->e_csets[ssid]);
>  
>  	init_waitqueue_head(&cgrp->offline_waitq);
> +	INIT_WORK(&cgrp->self.destroy_work, cgroup_release_agent);

It's weird to overload destroy_work like this as invoking
release_agent isn't necessarily related to destruction.  I like the
change overall but can we please just use a separate work item?

Thanks.

-- 
tejun
