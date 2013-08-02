Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab3HBECt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 00:02:49 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:25745 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3HBECs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 00:02:48 -0400
Message-ID: <51FB2F3D.5050904@huawei.com>
Date: Fri, 2 Aug 2013 12:02:05 +0800
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

> @@ -4199,12 +4208,13 @@ static void init_cgroup_css(struct cgroup_subsys_state *css,
>  /* invoke ->css_online() on a new CSS and mark it online if successful */
>  static int online_css(struct cgroup_subsys *ss, struct cgroup *cgrp)
>  {
> +	struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
>  	int ret = 0;
>  
>  	lockdep_assert_held(&cgroup_mutex);
>  
>  	if (ss->css_online)
> -		ret = ss->css_online(cgrp);
> +		ret = ss->css_online(css);
>  	if (!ret)
>  		cgrp->subsys[ss->subsys_id]->flags |= CSS_ONLINE;

Then this can be changed to css->flags |= CSS_ONLINE.

>  	return ret;

