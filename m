Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab3DWXr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 19:47:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:32979 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578Ab3DWXrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 19:47:55 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51771D8B.9000005@jp.fujitsu.com>
Date: Wed, 24 Apr 2013 08:47:23 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <hannes@cmpxchg.org>, <akpm@linux-foundation.org>, <linuxram@us.ibm.com>,
        <rientjes@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [Bug fix PATCH v5] Reusing a resource structure allocated by
 bootmem
References: <5175E5E8.3010003@jp.fujitsu.com> <1366751135.6660.3.camel@misato.fc.hp.com>
In-Reply-To: <1366751135.6660.3.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/04/24 6:05, Toshi Kani wrote:
> On Tue, 2013-04-23 at 10:37 +0900, Yasuaki Ishimatsu wrote:
>   :
>> The reason why the messages are shown is to release a resource structure,
>> allocated by bootmem, by kfree(). So when we release a resource structure,
>> we should check whether it is allocated by bootmem or not.
>>
>> But even if we know a resource structure is allocated by bootmem, we cannot
>> release it since SLxB cannot treat it. So for reusing a resource structure,
>> this patch remembers it by using bootmem_resource as follows:
>>
>> When releasing a resource structure by free_resource(), free_resource() checks
>> whether the resource structure is allocated by bootmem or not. If it is
>> allocated by bootmem, free_resource() adds it to bootmem_resource. If it is
>> not allocated by bootmem, free_resource() release it by kfree().
>>
>> And when getting a new resource structure by get_resource(), get_resource()
>> checks whether bootmem_resource has released resource structures or not. If
>> there is a released resource structure, get_resource() returns it. If there is
>> not a releaed resource structure, get_resource() returns new resource structure
>> allocated by kzalloc().
>> ---
>> v5:
>> Define bootmem_resource_free as static and poiner for saving memory
>> Fix slab check in free_resource()
>> Move memset outside of spin lock in get_resource()
>
> Please add your "Signed-off-by".  Otherwise the changes look good.
>
> Reviewed-by: Toshi Kani <toshi.kani@hp.com>

Thank you for your review.
I'll resend a patch with my "Signed-off-by" and your "Reviewed-by".

Thanks,
Yasuaki Ishimatsu

>
> Thanks,
> -Toshi
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


