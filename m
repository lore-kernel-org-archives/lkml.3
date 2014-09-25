Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaIYLEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 07:04:53 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:42075 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaIYLEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 07:04:52 -0400
Message-ID: <5423F6CF.5050802@mentor.com>
Date: Thu, 25 Sep 2014 14:04:47 +0300
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>,
        Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] genalloc: fix device node resource counter
References: <1411588260-29825-1-git-send-email-vladimir_zapolskiy@mentor.com> <20140924135831.ec76a8c60294a93e2da3b7af@linux-foundation.org>
In-Reply-To: <20140924135831.ec76a8c60294a93e2da3b7af@linux-foundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 24.09.2014 23:58, Andrew Morton wrote:
> On Wed, 24 Sep 2014 22:51:00 +0300 Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com> wrote:
>
>> The change balances a usage counter of np_pool device_node, which is
>> incremented on preceding of_parse_phandle() call.
>>
>> ...
>>
>> --- a/lib/genalloc.c
>> +++ b/lib/genalloc.c
>> @@ -637,6 +637,7 @@ struct gen_pool *of_get_named_gen_pool(struct device_node *np,
>>   	if (!np_pool)
>>   		return NULL;
>>   	pdev = of_find_device_by_node(np_pool);
>> +	of_node_put(np_pool);
>>   	if (!pdev)
>>   		return NULL;
>>   	return dev_get_gen_pool(&pdev->dev);
>
> Looks good, thanks.
>
> However...  when fixing a bug, please always describe the end-user
> visible effects of that bug.  Amongst other things this is to help me
> and others decide which kernel version(s) need the patch.
>
> I'm assuming that the effect will be, at worst, a memory leak at the
> rate of one device_node per hot-unplug event and is hence a very minor
> thing?
>

yes, you are correct, moreover there are not so many users of 
of_get_named_gen_pool() in vanilla (I counted 3), however since the 
change is in ./lib folder, it may be considered as relatively important 
one. I think it is sufficient to have the change in linux-next only.

With best wishes,
Vladimir
