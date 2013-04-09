Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964836Ab3DIHJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:09:10 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:6966 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936785Ab3DIHIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:08:51 -0400
Message-ID: <5163BE4C.5040301@huawei.com>
Date: Tue, 9 Apr 2013 15:07:56 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <mingo@redhat.com>, <a.p.zijlstra@chello.nl>, <paulus@samba.org>,
        <acme@ghostprotocols.net>, <eranian@google.com>,
        <namhyung.kim@lge.com>, <mhocko@suse.cz>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <cgroups@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET] perf, cgroup: implement hierarchy support for perf_event
 controller
References: <1365474213-13354-1-git-send-email-tj@kernel.org>
In-Reply-To: <1365474213-13354-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/9 10:23, Tejun Heo wrote:
> perf_event cgroup controller is one of the remaining few with broken
> hierarchy support.  It turns out it's pretty easy to implement - the
> only thing necessary is making perf_cgroup_match() return %true also
> when the cgroup of the current task is a descendant of the event's
> cgroup.  This patchset implements cgroup_is_descendant() and uses it
> to implement hierarchy support in perf_event controller.
> 
> This patchset contains the following three patches.
> 
>  0001-cgroup-make-sure-parent-won-t-be-destroyed-before-it.patch
>  0002-cgroup-implement-cgroup_is_descendant.patch
>  0003-perf-make-perf_event-cgroup-hierarchical.patch
> 
> The patches are also available in the following git branch, which is
> based on top of cgroup/for-3.10.  It's currently based on top of
> cgroup/for-3.10 as the first patch causes non-trivial conflict with it
> otherwise, which is not difficult to resolve but still nice to avoid
> anyway.
> 
> Li, Michal, I picked the first two patches from Li's memcg patchset.
> Can we push the first two through cgroup/for-3.10 and put the rest in
> -mm?
> 

Sure. Andrew asked me to resend the memcg patchset when we are at 3.10-rc1,
because 3.9-rc6 is a bit too late and he's too busy.

> Ingo, how should these be routed?

