Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab3HBDyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 23:54:46 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:56212 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3HBDyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 23:54:44 -0400
Message-ID: <51FB2D70.3040208@huawei.com>
Date: Fri, 2 Aug 2013 11:54:24 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        Aristeu Rozanski <aris@redhat.com>, Matt Helsley <matthltc@us.ibm.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 08/23] cgroup: pass around cgroup_subsys_state instead
 of cgroup in subsystem methods
References: <1375393801-4817-1-git-send-email-tj@kernel.org> <1375393801-4817-9-git-send-email-tj@kernel.org>
In-Reply-To: <1375393801-4817-9-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -4298,7 +4308,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
>  	for_each_root_subsys(root, ss) {
>  		struct cgroup_subsys_state *css;
>  
> -		css = ss->css_alloc(cgrp);
> +		css = ss->css_alloc(parent->subsys[ss->subsys_id]);

As this patchset is based on for-3.12 branch, which lacks the fix in for-3.11,
so the css_alloc() in that bug fix is not converted.

>  		if (IS_ERR(css)) {
>  			err = PTR_ERR(css);
>  			goto err_free_all;
> @@ -4377,7 +4387,7 @@ err_free_all:
>  
>  		if (css) {
>  			percpu_ref_cancel_init(&css->refcnt);
> -			ss->css_free(cgrp);
> +			ss->css_free(css);
>  		}
>  	}
>  	mutex_unlock(&cgroup_mutex);

