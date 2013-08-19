Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab3HSBj5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 21:39:57 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58223 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab3HSBj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 21:39:56 -0400
Message-ID: <52117765.7010205@ozlabs.ru>
Date: Mon, 19 Aug 2013 11:39:49 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Wei Yang <weiyang@linux.vnet.ibm.com>
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        benh@au1.ibm.com, paulus@au1.ibm.com
Subject: Re: [PATCH 2/2] powerpc/iommu: check dev->iommu_group before remove
 a device from iommu_group
References: <1376647687-20550-1-git-send-email-weiyang@linux.vnet.ibm.com> <1376647687-20550-3-git-send-email-weiyang@linux.vnet.ibm.com> <520DFBC8.4040509@ozlabs.ru> <20130819012945.GA8342@weiyang.vnet.ibm.com>
In-Reply-To: <20130819012945.GA8342@weiyang.vnet.ibm.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 11:29 AM, Wei Yang wrote:
> On Fri, Aug 16, 2013 at 08:15:36PM +1000, Alexey Kardashevskiy wrote:
>> On 08/16/2013 08:08 PM, Wei Yang wrote:
>>> ---
>>>  arch/powerpc/kernel/iommu.c |    3 ++-
>>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
>>> index b20ff17..5abf7c3 100644
>>> --- a/arch/powerpc/kernel/iommu.c
>>> +++ b/arch/powerpc/kernel/iommu.c
>>> @@ -1149,7 +1149,8 @@ static int iommu_bus_notifier(struct notifier_block *nb,
>>>  	case BUS_NOTIFY_ADD_DEVICE:
>>>  		return iommu_add_device(dev);
>>>  	case BUS_NOTIFY_DEL_DEVICE:
>>> -		iommu_del_device(dev);
>>> +		if (dev->iommu_group)
>>> +			iommu_del_device(dev);
>>>  		return 0;
>>>  	default:
>>>  		return 0;
>>>
>>
>> This one seems redundant, no?
> 
> Sorry for the late.
> 
> Yes, these two patches have the same purpose to guard the system, while in two
> different places.  One is in powernv platform, the other is in the generic iommu 
> driver.
> 
> The one in powernv platform is used to correct the original logic.
> 
> The one in generic iommu driver is to keep system safe in case other platform to
> call iommu_group_remove_device() without the check.


But I am moving bus notifier to powernv code (posted a patch last week,
otherwise Freescale's IOMMU conflicted) so this won't be the case.



-- 
Alexey
