Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3DQAOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 20:14:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36064 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3DQAOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 20:14:43 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <516DE958.1090200@jp.fujitsu.com>
Date: Wed, 17 Apr 2013 09:14:16 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <rientjes@google.com>, <linuxram@us.ibm.com>
Subject: Re: [Bug fix PATCH v2] Reusing a resource structure allocated by
 bootmem
References: <516CA4F1.9060603@jp.fujitsu.com> <1366124458.3824.30.camel@misato.fc.hp.com>
In-Reply-To: <1366124458.3824.30.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/04/17 0:00, Toshi Kani wrote:
> On Tue, 2013-04-16 at 10:10 +0900, Yasuaki Ishimatsu wrote:
>> When hot removing memory presented at boot time, following messages are shown:
>
>   :
>
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
>>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> ---
>> v2:
>> Based on following Toshi's works:
>>    Support memory hot-delete to boot memory
>>      https://lkml.org/lkml/2013/4/10/469
>>    resource: Update config option of release_mem_region_adjustable()
>>      https://lkml.org/lkml/2013/4/11/694
>> Added a NULL check into free_resource()
>> Remove __free_resource()
>
> Thanks for the update.  Looks good.  Can you also address Rui's comment?

Thank you for your review.
Of course I'll update Rui's comment.

Thanks,
Yasuaki Ishimatsu

>
> -Toshi
>
>


