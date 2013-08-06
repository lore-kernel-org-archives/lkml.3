Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab3HFGyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 02:54:04 -0400
Received: from mail.bmw-carit.de ([62.245.222.98]:44098 "EHLO
	mail.bmw-carit.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab3HFGyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 02:54:01 -0400
X-CTCH-RefID: str=0001.0A0C0208.52009C30.000E,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
Message-ID: <52009C2F.2040101@bmw-carit.de>
Date: Tue, 6 Aug 2013 08:48:15 +0200
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <lizefan@huawei.com>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        Aristeu Rozanski <aris@redhat.com>, Matt Helsley <matthltc@us.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 12/23] cgroup: pass around cgroup_subsys_state instead
 of cgroup in file methods
References: <1375393801-4817-1-git-send-email-tj@kernel.org> <1375393801-4817-13-git-send-email-tj@kernel.org>
In-Reply-To: <1375393801-4817-13-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.101.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 08/01/2013 11:49 PM, Tejun Heo wrote:
> cgroup is currently in the process of transitioning to using struct
> cgroup_subsys_state * as the primary handle instead of struct cgroup.
> Please see the previous commit which converts the subsystem methods
> for rationale.
>
> This patch converts all cftype file operations to take @css instead of
> @cgroup.  cftypes for the cgroup core files don't have their subsytem
> pointer set.  These will automatically use the dummy_css added by the
> previous patch and can be converted the same way.
>
> Most subsystem conversions are straight forwards but there are some
> interesting ones.
>
> * freezer: update_if_frozen() is also converted to take @css instead
>    of @cgroup for consistency.  This will make the code look simpler
>    too once iterators are converted to use css.
>
> * memory/vmpressure: mem_cgroup_from_css() needs to be exported to
>    vmpressure while mem_cgroup_from_cont() can be made static.
>    Updated accordingly.
>
> * cpu: cgroup_tg() doesn't have any user left.  Removed.
>
> * cpuacct: cgroup_ca() doesn't have any user left.  Removed.
>
> * hugetlb: hugetlb_cgroup_form_cgroup() doesn't have any user left.
>    Removed.
>
> * net_cls: cgrp_cls_state() doesn't have any user left.  Removed.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: Aristeu Rozanski <aris@redhat.com>
> Cc: Matt Helsley <matthltc@us.ibm.com>
> Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Steven Rostedt <rostedt@goodmis.org>

I guess I ended up because I did some changes on netprio_cgroup and 
cls_cgroup.

Acked-by: Daniel Wagner <daniel.wagner@bmw-carit.de>

cheers,
daniel
