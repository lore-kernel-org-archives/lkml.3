Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaA2Qsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 11:48:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbaA2Qst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 11:48:49 -0500
Date: Wed, 29 Jan 2014 11:23:26 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vivek Goyal <vgoyal@redhat.com>, Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH 3/6] cgroup: clean up cgroup_subsys names and
 initialization
Message-ID: <20140129162325.GI15457@redhat.com>
References: <1390952641-15950-1-git-send-email-tj@kernel.org>
 <1390952641-15950-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390952641-15950-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -58,11 +58,9 @@ static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
>  
>  static inline struct dev_cgroup *task_devcgroup(struct task_struct *task)
>  {
> -	return css_to_devcgroup(task_css(task, devices_subsys_id));
> +	return css_to_devcgroup(task_css(task, devices_cgrp_id));
>  }
>  
> -struct cgroup_subsys devices_subsys;
> -
>  /*
>   * called under devcgroup_mutex
>   */
> @@ -684,13 +682,11 @@ static struct cftype dev_cgroup_files[] = {
>  	{ }	/* terminate */
>  };
>  
> -struct cgroup_subsys devices_subsys = {
> -	.name = "devices",
> +struct cgroup_subsys devices_cgrp_subsys = {
>  	.css_alloc = devcgroup_css_alloc,
>  	.css_free = devcgroup_css_free,
>  	.css_online = devcgroup_online,
>  	.css_offline = devcgroup_offline,
> -	.subsys_id = devices_subsys_id,
>  	.base_cftypes = dev_cgroup_files,
>  };

ACK

-- 
Aristeu

