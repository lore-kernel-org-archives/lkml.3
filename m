Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbaC1CvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 22:51:02 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:4584 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794AbaC1CvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 22:51:00 -0400
Message-ID: <5334E2F1.3040809@huawei.com>
Date: Fri, 28 Mar 2014 10:48:17 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: Tejun Heo <tj@kernel.org>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: missing rcu read lock around task_css_set
References: <1393729211-937-1-git-send-email-sasha.levin@oracle.com> <20140303223327.GB26523@mtj.dyndns.org> <5315057F.3030602@oracle.com> <20140303224505.GE26523@mtj.dyndns.org> <53150989.70307@oracle.com> <53160B6D.8020501@oracle.com> <20140304194741.GA2204@htj.dyndns.org> <53167662.5000801@huawei.com> <5334452D.4080200@oracle.com>
In-Reply-To: <5334452D.4080200@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/27 23:35, Sasha Levin wrote:
> On 03/04/2014 07:57 PM, Li Zefan wrote:
>> On 2014/3/5 3:47, Tejun Heo wrote:
>>> On Tue, Mar 04, 2014 at 12:20:45PM -0500, Sasha Levin wrote:
>>>>> Hrm... there is a PF_EXITING check there already:
>>>>>
>>>>>      #define task_css_set_check(task, __c)            \
>>>>>          rcu_dereference_check((task)->cgroups,        \
>>>>>          lockdep_is_held(&cgroup_mutex) ||        \
>>>>>          lockdep_is_held(&css_set_rwsem) ||        \
>>>>>          ((task)->flags & PF_EXITING) || (__c))
>>>>>
>>>>> I see it's not happening on Linus's master so I'll run a bisection to figure out what broke it.
>>>>
>>>> Hi Tejun,
>>>>
>>>> It bisects down to your patch: "cgroup: drop task_lock() protection
>>>> around task->cgroups". I'll look into it later unless it's obvious
>>>> to you.
>>>
>>> Hmmm... maybe I'm confused and PF_EXITING is not set there and
>>> task_lock was what held off the lockdep warning.  Confused....
>>>
>>
>> Because this cgroup_exit() is called in a failure path in copy_process().
> 
> It seems there was no conclusion here and it still happens in -next, anything
> we can do about it?
> 

I'll send a patch to fix it. Thanks!

