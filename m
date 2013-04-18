Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967571Ab3DRXt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 19:49:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60583 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936608Ab3DRXt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 19:49:27 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5170853B.2040807@jp.fujitsu.com>
Date: Fri, 19 Apr 2013 08:43:55 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <akpm@linux-foundation.org>, <linuxram@us.ibm.com>, <rientjes@google.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [Bug fix PATCH v4] Reusing a resource structure allocated by
 bootmem
References: <516FB07C.9010603@jp.fujitsu.com>  <1366295000.3824.47.camel@misato.fc.hp.com>  <517082B9.7050708@jp.fujitsu.com> <1366327735.3824.50.camel@misato.fc.hp.com>
In-Reply-To: <1366327735.3824.50.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/04/19 8:28, Toshi Kani wrote:
> On Fri, 2013-04-19 at 08:33 +0900, Yasuaki Ishimatsu wrote:
>   :
>>>
>>>> +static struct resource *get_resource(gfp_t flags)
>>>> +{
>>>> +	struct resource *res = NULL;
>>>> +
>>>> +	spin_lock(&bootmem_resource_lock);
>>>> +	if (bootmem_resource.sibling) {
>>>> +		res = bootmem_resource.sibling;
>>>> +		bootmem_resource.sibling = res->sibling;
>>>> +		memset(res, 0, sizeof(struct resource));
>>>> +	}
>>>> +	spin_unlock(&bootmem_resource_lock);
>>>
>>
>>> I prefer to keep memset() outside of the spin lock.
>>>
>>> spin_lock(&bootmem_resource_lock);
>>> if (..) {
>>> 	:
>>> 	spin_unlock(&bootmem_resource_lock);
>>> 	memset(res, 0, sizeof(struct resource));
>>> } else {
>>> 	spin_unlock(&bootmem_resource_lock);
>>> 	res = kzalloc(sizeof(struct resource), flags);
>>> }
>>
>> Hmm. It is a little ugly. How about it?
>>
>> spin_lock(&bootmem_resource_lock);
>> if (bootmem_resource.sibling) {
>> 	res = bootmem_resource.sibling;
>> 	bootmem_resource.sibling = res->sibling;
>> }
>> spin_unlock(&bootmem_resource_lock);
>>
>> if (res)
>> 	memset(res, 0, sizeof(struct resource));
>> else	
>> 	res = kzalloc(sizeof(struct resource), flags);
>

> Sounds good to me.

Great. I'll update it.

Thanks,
Yasuaki Ishimatsu

>
> Thanks,
> -Toshi
>
>


