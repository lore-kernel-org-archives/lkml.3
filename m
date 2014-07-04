Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbaGDJ3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:29:01 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:36378 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaGDJ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:28:59 -0400
Message-ID: <53B673CF.2040101@huawei.com>
Date: Fri, 4 Jul 2014 17:28:47 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: David Woodhouse <dwmw2@infradead.org>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] iommu/vt-d: move up no_iommu and dmar_disabled check
References: <1400589472-8544-1-git-send-email-wangyijing@huawei.com> <1400589472-8544-3-git-send-email-wangyijing@huawei.com> <20140704090640.GS26537@8bytes.org>
In-Reply-To: <20140704090640.GS26537@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>> index e020dcf..6b71608 100644
>> --- a/drivers/iommu/intel-iommu.c
>> +++ b/drivers/iommu/intel-iommu.c
>> @@ -3948,6 +3948,9 @@ int __init intel_iommu_init(void)
>>  	/* VT-d is required for a TXT/tboot launch, so enforce that */
>>  	force_on = tboot_force_iommu();
>>  
>> +	if (no_iommu || dmar_disabled)
>> +		return ret;
>> +
>>  	if (iommu_init_mempool()) {
>>  		if (force_on)
>>  			panic("tboot: Failed to initialize iommu memory\n");
>> @@ -3974,9 +3977,6 @@ int __init intel_iommu_init(void)
>>  		goto out_free_dmar;
>>  	}
>>  
>> -	if (no_iommu || dmar_disabled)
>> -		goto out_free_dmar;
>> -
>>  	if (list_empty(&dmar_rmrr_units))
>>  		printk(KERN_INFO "DMAR: No RMRR found\n");
> 
> This breaks the kexec case were the old kernel had VT-d enabled and the
> new one disabled. In this case the new kernel might need to disable the
> IOMMUs.

Hi Joerg,
   Thanks for your review and comments! You are right, I didn't consider the kexec case,
I will drop this patch.

Thanks!
Yijing.


> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


-- 
Thanks!
Yijing

