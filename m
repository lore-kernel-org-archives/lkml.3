Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab3CIHvT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 02:51:19 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:33210 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab3CIHvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 02:51:18 -0500
Message-ID: <513AE918.7020704@huawei.com>
Date: Sat, 9 Mar 2013 15:47:36 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, <cgroups@vger.kernel.org>
Subject: Re: lockdep trace from prepare_bprm_creds
References: <20130306223657.GA7392@redhat.com> <20130307172545.GA10353@redhat.com> <20130307180139.GD29601@htj.dyndns.org> <20130307180332.GE29601@htj.dyndns.org> <20130307191242.GA18265@redhat.com> <20130307193820.GB3209@htj.dyndns.org> <513A9A67.60909@huawei.com> <20130309032936.GT14556@mtj.dyndns.org>
In-Reply-To: <20130309032936.GT14556@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/9 11:29, Tejun Heo wrote:
> Hello, Li.
> 
> On Sat, Mar 09, 2013 at 10:11:51AM +0800, Li Zefan wrote:
>> On 2013/3/8 3:38, Tejun Heo wrote:
>>> On Thu, Mar 07, 2013 at 08:12:42PM +0100, Oleg Nesterov wrote:
>>>> Well yes, I agree. I think that perfomance-wise threadgroup_change_begin()
>>>> in de_thread() is fine, and perhaps it is even more clean because we are
>>>> going to do the thread-group change. The scope of cred_guard_mutex is huge,
>>>> it doesn't look very nice in threadgroup_lock().
>>>>
>>>> But we should avoid the cgroup-specific hooks as much as possible, so I
>>>> like your patch more.
>>>
>>> I don't really mind how it's done but while my approach seems to limit
>>> itself to cgroup proper, threadgroup locking is actually more invasive
>>> by meddling with cred_mutex.  As you said, yours is the cleaner and
>>> probably more permanent one here.
>>>
>>
>> Agreed.
>>
>> Now we need that patch to be resent with SOB and proper changelog.
> 
> Now that I think more about it, I think I want both patches.  It is
> bothering that threadgroup lock is nested inside cgroup_lock.  It
> always has.  I just couldn't do anything about that until recently.
> Li, can you be persuaded into getting the lock reordering patch into a
> useable shape?  :)
> 

The patch is actually already in good shape. 

I'll give it some test and then you can queue it?

We don't need both patches for 3.9, so we'll queue Oleg's fix for 3.9 and
yours for 3.10?
