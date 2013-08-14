Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3HNGpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 02:45:16 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:3505 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab3HNGpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 02:45:15 -0400
Message-ID: <520B2768.1090001@huawei.com>
Date: Wed, 14 Aug 2013 14:44:56 +0800
From: Rui Xiang <rui.xiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: <linux-kernel@vger.kernel.org>, <oleg@redhat.com>
Subject: Re: [PATCH] userns: initialize the depth of user_namespace chain
References: <520B0FCF.5080809@huawei.com> <CALCETrUJTMVo4sCiVRHvVocja3Q9_hXPdc1xQ0D+EtPUT_2T7w@mail.gmail.com>
In-Reply-To: <CALCETrUJTMVo4sCiVRHvVocja3Q9_hXPdc1xQ0D+EtPUT_2T7w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/14 13:06, Andy Lutomirski wrote:
> On Tue, Aug 13, 2013 at 10:04 PM, Rui Xiang <rui.xiang@huawei.com> wrote:
>> The level of init_user_ns shoule be 1.
> 
> What's wrong with zero?
> 

No problem. It is just consistent with commit 8742f229b63, IMHO.
but the initialization of level should be necessary.


Thanks.

> --Andy
> 
>>
>> Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
>> ---
>>  kernel/user.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/kernel/user.c b/kernel/user.c
>> index 69b4c3d..32da187 100644
>> --- a/kernel/user.c
>> +++ b/kernel/user.c
>> @@ -48,6 +48,7 @@ struct user_namespace init_user_ns = {
>>                 },
>>         },
>>         .count = ATOMIC_INIT(3),
>> +       .level = 1,
>>         .owner = GLOBAL_ROOT_UID,
>>         .group = GLOBAL_ROOT_GID,
>>         .proc_inum = PROC_USER_INIT_INO,
>> --
>> 1.8.2.2
>>
> 
> 
> 


