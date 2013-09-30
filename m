Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab3I3IOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 04:14:17 -0400
Received: from relay.parallels.com ([195.214.232.42]:36229 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab3I3IOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 04:14:11 -0400
Message-ID: <524932CB.6040904@parallels.com>
Date: Mon, 30 Sep 2013 12:14:03 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130827 Icedove/17.0.8
MIME-Version: 1.0
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
CC: <mingo@kernel.org>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <pjt@google.com>, <peterz@infradead.org>, <tglx@linutronix.de>,
        <lkp@01.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Huang Ying <ying.huang@intel.com>, <linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:sched/core] sched/balancing: Fix cfs_rq-> task_h_load calculation
References: <1379173186-11944-1-git-send-email-vdavydov@parallels.com> <tip-7e3115ef5149fc502e3a2e80719dba54a8e7409d@git.kernel.org> <20130929094714.GM24743@yliu-dev.sh.intel.com>
In-Reply-To: <20130929094714.GM24743@yliu-dev.sh.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 01:47 PM, Yuanhan Liu wrote:
> On Fri, Sep 20, 2013 at 06:46:59AM -0700, tip-bot for Vladimir Davydov wrote:
>> Commit-ID:  7e3115ef5149fc502e3a2e80719dba54a8e7409d
>> Gitweb:http://git.kernel.org/tip/7e3115ef5149fc502e3a2e80719dba54a8e7409d
>> Author:     Vladimir Davydov<vdavydov@parallels.com>
>> AuthorDate: Sat, 14 Sep 2013 19:39:46 +0400
>> Committer:  Ingo Molnar<mingo@kernel.org>
>> CommitDate: Fri, 20 Sep 2013 11:59:39 +0200
>>
>> sched/balancing: Fix cfs_rq->task_h_load calculation
>>
>> Patch a003a2 (sched: Consider runnable load average in move_tasks())
>> sets all top-level cfs_rqs' h_load to rq->avg.load_avg_contrib, which is
>> always 0. This mistype leads to all tasks having weight 0 when load
>> balancing in a cpu-cgroup enabled setup. There obviously should be sum
>> of weights of all runnable tasks there instead. Fix it.
> Hi Vladimir,
>
> FYI, Here we found a 17% netperf regression by this patch. Here are some
> changed stats between this commit 7e3115ef5149fc502e3a2e80719dba54a8e7409d
> and it's parent(3029ede39373c368f402a76896600d85a4f7121b)

Hello,

Could you please report the following info:

1) the test machine cpu topology (i.e. output of 
/sys/devices/system/cpu/cpu*/{thread_siblings_list,core_siblings_list})
2) kernel config you used during the test
3) the output of /sys/kernel/debug/sched_features (debugfs mounted).
4) netperf server/client options
5) did you place netserver into a separate cpu cgroup?

Thanks.
