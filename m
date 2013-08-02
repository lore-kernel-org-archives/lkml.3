Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab3HBEKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 00:10:46 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:2889 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3HBEKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 00:10:45 -0400
Message-ID: <51FB30D3.9030900@huawei.com>
Date: Fri, 2 Aug 2013 12:08:51 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 21/23] cgroup: make cftype->[un]register_event() deal
 with cgroup_subsys_state instead of cgroup
References: <1375393801-4817-1-git-send-email-tj@kernel.org> <1375393801-4817-22-git-send-email-tj@kernel.org>
In-Reply-To: <1375393801-4817-22-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -506,15 +506,17 @@ struct cftype {
>  	 * you want to provide this functionality. Use eventfd_signal()
>  	 * on eventfd to send notification to userspace.
>  	 */
> -	int (*register_event)(struct cgroup *cgrp, struct cftype *cft,
> -			struct eventfd_ctx *eventfd, const char *args);
> +	int (*register_event)(struct cgroup_subsys_state *css,
> +			      struct cftype *cft, struct eventfd_ctx *eventfd,
> +			      const char *args);
>  	/*
>  	 * unregister_event() callback will be called when userspace
>  	 * closes the eventfd or on cgroup removing.
>  	 * This callback must be implemented, if you want provide
>  	 * notification functionality.
>  	 */
> -	void (*unregister_event)(struct cgroup *cgrp, struct cftype *cft,
> +	void (*unregister_event)(struct cgroup_subsys_state *css,
> +				 struct cftype *cft,
>  			struct eventfd_ctx *eventfd);

align this line?

>  };

