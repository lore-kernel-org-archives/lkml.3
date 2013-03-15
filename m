Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab3COBnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 21:43:50 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:50393 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab3COBnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 21:43:49 -0400
Message-ID: <51427CA4.2060803@huawei.com>
Date: Fri, 15 Mar 2013 09:43:00 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: li guang <lig.fnst@cn.fujitsu.com>
CC: Oleg Nesterov <oleg@redhat.com>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] task_work: check callback if it's NULL
References: <1363247865-3531-1-git-send-email-lig.fnst@cn.fujitsu.com>  <1363247865-3531-2-git-send-email-lig.fnst@cn.fujitsu.com>  <20130314144307.GB16136@redhat.com>  <1363306834.21129.121.camel@liguang.fnst.cn.fujitsu.com>  <514272D3.7040901@huawei.com> <1363310769.21129.132.camel@liguang.fnst.cn.fujitsu.com>
In-Reply-To: <1363310769.21129.132.camel@liguang.fnst.cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/15 9:26, li guang wrote:
> 在 2013-03-15五的 09:01 +0800，Li Zefan写道：
>> On 2013/3/15 8:20, li guang wrote:
>>> 在 2013-03-14四的 15:43 +0100，Oleg Nesterov写道：
>>>> On 03/14, liguang wrote:
>>>>>
>>>>> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
>>>>> ---
>>>>>  kernel/task_work.c |    3 ++-
>>>>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>>>>
>>>>> diff --git a/kernel/task_work.c b/kernel/task_work.c
>>>>> index 0bf4258..f458b08 100644
>>>>> --- a/kernel/task_work.c
>>>>> +++ b/kernel/task_work.c
>>>>> @@ -75,7 +75,8 @@ void task_work_run(void)
>>>>>
>>>>>  		do {
>>>>>  			next = work->next;
>>>>> -			work->func(work);
>>>>> +			if (unlikely(work->func))
>>>>> +				work->func(work);
>>>>
>>>> Why?
>>>>
>>>> Oleg.
>>>>
>>>
>>> can we believe a callback always be call-able?
>>> can it happened to be 0? e.g. wrong initialized.
>>> of course, we can complain the caller, be why don't
>>> we easily make it more safer?
>>>
>>
>> Because you're not making things safer, but your're trying
>> to cover up bugs...
>>
> 
> Oh, that's a little harsh to a normal programmer like me :-)
> for it seems you are asking me to be coding without any bug.
> are you? or it is the theory of kernel coding?
> 

And you make a bug, and you want the kernel to cover up the bug
instead of crash on a null pointer deref so you'll know you've
made a bug?

Why we check if a callback is NULL before calling it? Because
it's allowed to be. Why we don't check if a callback is NULL?
Because it's not supposed to be.

