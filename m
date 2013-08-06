Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3HFGxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 02:53:43 -0400
Received: from mail.bmw-carit.de ([62.245.222.98]:44023 "EHLO
	mail.bmw-carit.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab3HFGxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 02:53:41 -0400
X-CTCH-RefID: str=0001.0A0C0208.52009D6F.002F,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
Message-ID: <52009D6D.10507@bmw-carit.de>
Date: Tue, 6 Aug 2013 08:53:33 +0200
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <lizefan@huawei.com>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Matt Helsley <matthltc@us.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 22/23] cgroup: make cgroup_taskset deal with cgroup_subsys_state
 instead of cgroup
References: <1375393801-4817-1-git-send-email-tj@kernel.org> <1375393801-4817-23-git-send-email-tj@kernel.org>
In-Reply-To: <1375393801-4817-23-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.101.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 08/01/2013 11:50 PM, Tejun Heo wrote:
> cgroup is in the process of converting to css (cgroup_subsys_state)
> from cgroup as the principal subsystem interface handle.  This is
> mostly to prepare for the unified hierarchy support where css's will
> be created and destroyed dynamically but also helps cleaning up
> subsystem implementations as css is usually what they are interested
> in anyway.
>
> cgroup_taskset which is used by the subsystem attach methods is the
> last cgroup subsystem API which isn't using css as the handle.  Update
> cgroup_taskset_cur_cgroup() to cgroup_taskset_cur_css() and
> cgroup_taskset_for_each() to take @skip_css instead of @skip_cgrp.
>
> The conversions are pretty mechanical.  One exception is
> cpuset::cgroup_cs(), which lost its last user and got removed.
>
> This patch shouldn't introduce any functional changes.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Matt Helsley <matthltc@us.ibm.com>
> Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Nice cleanup.

Acked-By: Daniel Wagner <daniel.wagner@bmw-carit.de>

cheers,
daniel






