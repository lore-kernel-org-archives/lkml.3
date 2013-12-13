Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab3LMDCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 22:02:18 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58632 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3LMDCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 22:02:16 -0500
Message-ID: <52AA78AE.2050800@ozlabs.ru>
Date: Fri, 13 Dec 2013 14:02:06 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: Re: [1/3] powerpc/vfio: Enable on POWERNV platform
References: <1369107191-28547-2-git-send-email-aik@ozlabs.ru> <20131212233527.GA16929@home.buserror.net>
In-Reply-To: <20131212233527.GA16929@home.buserror.net>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 10:35 AM, Scott Wood wrote:
> On Tue, May 21, 2013 at 01:33:09PM +1000, Alexey Kardashevskiy wrote:
>> +static int iommu_add_device(struct device *dev)
>> +{
>> +	struct iommu_table *tbl;
>> +	int ret = 0;
>> +
>> +	if (WARN_ON(dev->iommu_group)) {
>> +		pr_warn("iommu_tce: device %s is already in iommu group %d, skipping\n",
>> +				dev_name(dev),
>> +				iommu_group_id(dev->iommu_group));
>> +		return -EBUSY;
>> +	}
> [snip]
>> +static int __init tce_iommu_init(void)
>> +{
>> +	struct pci_dev *pdev = NULL;
>> +
>> +	BUILD_BUG_ON(PAGE_SIZE < IOMMU_PAGE_SIZE);
>> +
>> +	for_each_pci_dev(pdev)
>> +		iommu_add_device(&pdev->dev);
>> +
>> +	bus_register_notifier(&pci_bus_type, &tce_iommu_bus_nb);
>> +	return 0;
>> +}
>> +
>> +subsys_initcall_sync(tce_iommu_init);
> 
> This is missing a check to see whether the appropriate hardware is
> present.  This file should also be renamed to something less generic, and
> depend on a kconfig symbol more specific than CONFIG_PPC64.
> 
> When this is combined with CONFIG_FSL_PAMU on hardware with a PAMU, I get
> a bunch of those "WARN_ON(dev->iommu_group)" dumps because PAMU already
> got to them.  Presumably without PAMU it silently (or with just pr_debug)
> bails out at some other point.


I posted (yet again) yesterday "[PATCH v11] PPC: POWERNV: move
iommu_add_device earlier" which should fix this. And Bharat asked many
times for this to get accepted :)



-- 
Alexey
