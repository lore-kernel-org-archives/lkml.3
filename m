Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3EAIEC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 04:04:02 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:52941 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3EAIDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 04:03:46 -0400
Message-ID: <5180CC5B.3010608@kernel.org>
Date: Wed, 01 May 2013 11:03:39 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, glommer@parallels.com,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
References: <CAOJsxLFYDC+EDdJrXVnc1qfEyd56bhFLeGE+6Mbhwiq73KQQLQ@mail.gmail.com> <517E8758.9040803@parallels.com> <0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com> <201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp> <0000013e56e9304a-1042a95a-d4dd-43c5-8b8a-c670f50ac54e-000000@email.amazonses.com> <201304300645.FCE37285.tVHJLSOMQFOFFO@I-love.SAKURA.ne.jp> <0000013e5b5de8c2-75b84016-0faf-4b7f-b5e5-e40eb67552ab-000000@email.amazonses.com>
In-Reply-To: <0000013e5b5de8c2-75b84016-0faf-4b7f-b5e5-e40eb67552ab-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/13 5:34 PM, Christoph Lameter wrote:
> On Tue, 30 Apr 2013, Tetsuo Handa wrote:
>
>> Current diff is:
>
> [off by one stuff okay]
>
>> diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
>> index 113ec08..be1446a 100644
>> --- a/include/linux/slab_def.h
>> +++ b/include/linux/slab_def.h
>> @@ -126,6 +126,9 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
>>   		if (!size)
>>   			return ZERO_SIZE_PTR;
>>
>> +		if (size > KMALLOC_MAX_SIZE)
>> +			goto not_found;
>> +
>>   		i = kmalloc_index(size);
>
> Why is this needed? kmalloc_index should BUG() for too large allocs.

Why is that? Historically it has returned NULL, hasn't it? We have had 
cases where kernel code (naively) uses size directly from userspace and 
we definitely don't want to BUG_ON on it.

			Pekka
