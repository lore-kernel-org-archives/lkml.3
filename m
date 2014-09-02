Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbaIBPvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:51:24 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:49114 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbaIBPvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:51:23 -0400
Date: Tue, 2 Sep 2014 11:51:19 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/2] cgroup: check cgroup liveliness before unbreaking
 kernfs protection
Message-ID: <20140902155119.GB17424@htj.dyndns.org>
References: <5405A27A.3090605@huawei.com>
 <5405A2B2.4010406@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5405A2B2.4010406@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 06:57:54PM +0800, Li Zefan wrote:
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index e03fc62..c8d07e5 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1025,6 +1025,11 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
>  	return mode;
>  }
>  
> +static bool cgroup_tryget(struct cgroup *cgrp)
> +{
> +	return css_tryget(&cgrp->self);
> +}

Can you please move this right below cgroup_get() definition?

Thanks.

-- 
tejun
