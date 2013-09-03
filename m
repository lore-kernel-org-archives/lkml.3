Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248Ab3ICDPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 23:15:53 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44573 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab3ICDPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 23:15:52 -0400
Date: Tue, 3 Sep 2013 11:15:44 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, aik@ozlabs.ru, paulus@au1.ibm.com,
        benh@au1.ibm.com, iommu <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH] iommu: WARN_ON when removing a device with no
 iommu_group associated
Message-ID: <20130903031544.GA16232@weiyang.vnet.ibm.com>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1377222911-12144-1-git-send-email-weiyang@linux.vnet.ibm.com>
 <1377228807.25163.33.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377228807.25163.33.camel@ul30vt.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090302-9264-0000-0000-000004738870
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any more comments? Or this one is not proper?

On Thu, Aug 22, 2013 at 09:33:27PM -0600, Alex Williamson wrote:
>[+cc iommu]
>
>On Fri, 2013-08-23 at 09:55 +0800, Wei Yang wrote:
>> When removing a device from the system, iommu_group driver will try to
>> disconnect it from its group. While in some cases, one device may not
>> associated with any iommu_group. For example, not enough DMA address space.
>> 
>> In the generic bus notification, it will check dev->iommu_group before calling
>> iommu_group_remove_device(). While in some cases, developers may call
>> iommu_group_remove_device() in a different code path and without check. For
>> those devices with dev->iommu_group set to NULL, kernel will crash.
>> 
>> This patch gives a warning and return when trying to remove a device from an
>> iommu_group with dev->iommu_group set to NULL. This helps to indicate some bad
>> behavior and also guard the kernel.
>> 
>> Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
>
>Acked-by: Alex Williamson <alex.williamson@redhat.com>
>
>> ---
>>  drivers/iommu/iommu.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>> 
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index fbe9ca7..43396f0 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -379,6 +379,9 @@ void iommu_group_remove_device(struct device *dev)
>>  	struct iommu_group *group = dev->iommu_group;
>>  	struct iommu_device *tmp_device, *device = NULL;
>>  
>> +	if (WARN_ON(!group))
>> +		return;
>> +
>>  	/* Pre-notify listeners that a device is being removed. */
>>  	blocking_notifier_call_chain(&group->notifier,
>>  				     IOMMU_GROUP_NOTIFY_DEL_DEVICE, dev);
>
>

-- 
Richard Yang
Help you, Help me

