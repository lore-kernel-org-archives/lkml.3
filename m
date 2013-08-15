Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030Ab3HOBvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 21:51:16 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:18822 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582Ab3HOBvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 21:51:15 -0400
Message-ID: <520C33FA.5080603@huawei.com>
Date: Thu, 15 Aug 2013 09:50:50 +0800
From: Rui Xiang <rui.xiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andy Lutomirski <luto@amacapital.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] userns: initialize the depth of user_namespace chain
References: <520B0FCF.5080809@huawei.com> <CALCETrUJTMVo4sCiVRHvVocja3Q9_hXPdc1xQ0D+EtPUT_2T7w@mail.gmail.com> <520B2768.1090001@huawei.com> <20130814184352.GA6381@redhat.com>
In-Reply-To: <20130814184352.GA6381@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/15 2:43, Oleg Nesterov wrote:
> On 08/14, Rui Xiang wrote:
>>
>> On 2013/8/14 13:06, Andy Lutomirski wrote:
>>> On Tue, Aug 13, 2013 at 10:04 PM, Rui Xiang <rui.xiang@huawei.com> wrote:
>>>> The level of init_user_ns shoule be 1.
>>>
>>> What's wrong with zero?
>>>
>>
>> No problem. It is just consistent with commit 8742f229b63, IMHO.
> 
> Well, I am fine either way,
> 
>> but the initialization of level should be necessary.
> 
> but it is not necessary. This is just an "arbitrary" limit for now,
> 32 non-root namespaces. Perhaps we should count init_user_ns too.
> 
> Hmm. but I just realized that "> 32" in create_user_ns() should be
> ">= 32" in this case.
> 
Yes. If we need to count init_user_ns, this filed should be set to 1 in 
init_user_ns, and "> 32" in create_user_ns() can limit 32 non-root 
namespaces. And that depends on your design. :)



Thanks.


