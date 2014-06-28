Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaF1L6p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 07:58:45 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:53388 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaF1L6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 07:58:43 -0400
Date: Sat, 28 Jun 2014 07:58:39 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] cgroup: fix mount failure in a corner case
Message-ID: <20140628115743.GB10829@htj.dyndns.org>
References: <53AD18D0.3090100@huawei.com>
 <53AD2852.2060304@huawei.com>
 <53AD35A8.7030908@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AD35A8.7030908@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Fri, Jun 27, 2014 at 05:13:12PM +0800, Li Zefan wrote:
> +	for_each_subsys(ss, i) {
> +		if (!(opts.subsys_mask & (1 << i)) ||
> +		    ss->root == &cgrp_dfl_root)
> +			continue;
> +
> +		if (!percpu_ref_tryget_live(&ss->root->cgrp.self.refcnt)) {
> +			mutex_unlock(&cgroup_mutex);
> +			msleep(10);
> +			ret = restart_syscall();
> +			goto out_free;
> +		}

Why not just put it immediately?  We know that it's not gonna be
destroyed while holding cgroup_mutex.  It may look a bit weird but
this is a pretty special case anyway and deferring put doesn't buy
anything.

Thanks.

-- 
tejun
