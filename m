Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaBLHwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 02:52:46 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:6346 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaBLHwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 02:52:44 -0500
Message-ID: <52FB2834.3090408@huawei.com>
Date: Wed, 12 Feb 2014 15:52:20 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "Johannes Weiner" <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 6/8] cgroup: remove cgroup->name
References: <1391877509-10855-1-git-send-email-tj@kernel.org> <1391877509-10855-7-git-send-email-tj@kernel.org>
In-Reply-To: <1391877509-10855-7-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index dd52e7f..30eee3b 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -111,8 +111,7 @@ static char *task_group_path(struct task_group *tg)
>  	if (autogroup_path(tg, group_path, PATH_MAX))
>  		return group_path;
>  
> -	cgroup_path(tg->css.cgroup, group_path, PATH_MAX);
> -	return group_path;
> +	return cgroup_path(tg->css.cgroup, group_path, PATH_MAX);

The caller won't check the return value but pass it to printk/seq_printf,
but now cgroup_path() might return -ENAMETOOLONG..

