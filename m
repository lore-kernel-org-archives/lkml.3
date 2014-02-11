Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaBKQfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:35:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbaBKQ01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:26:27 -0500
Date: Tue, 11 Feb 2014 17:26:25 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH cgroup/for-3.14-fixes] cgroup: protect modifications to
 cgroup_idr with cgroup_mutex
Message-ID: <20140211162625.GP11946@dhcp22.suse.cz>
References: <52F9D9DA.7040108@huawei.com>
 <20140211154105.GC24490@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211154105.GC24490@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 11-02-14 10:41:05, Tejun Heo wrote:
[...]
> @@ -4254,12 +4256,12 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
>  
>  	return 0;
>  
> -err_unlock:
> -	mutex_unlock(&cgroup_mutex);
> -	/* Release the reference count that we took on the superblock */
> -	deactivate_super(sb);
>  err_free_id:
>  	idr_remove(&root->cgroup_idr, cgrp->id);
> +	/* Release the reference count that we took on the superblock */
> +	deactivate_super(sb);
> +err_unlock:
> +	mutex_unlock(&cgroup_mutex);
>  err_free_name:
>  	kfree(rcu_dereference_raw(cgrp->name));
>  err_free_cgrp:

Do I have to change deactivate_super vs. mutex_unlock ordering in my
backport for 3.12 as well?
-- 
Michal Hocko
SUSE Labs
