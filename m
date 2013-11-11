Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054Ab3KKAzx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 19:55:53 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:43477 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3KKAzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 19:55:49 -0500
Message-ID: <52802AE8.6070803@huawei.com>
Date: Mon, 11 Nov 2013 08:55:04 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Joerg Roedel <joro@8bytes.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "Vinod Koul" <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH 1/1] IOMMU: Save pci device id instead of pci_dev* pointer
 for DMAR devices
References: <1383639898-48776-1-git-send-email-wangyijing@huawei.com> <1383639898-48776-2-git-send-email-wangyijing@huawei.com> <20131107180713.GA2955@google.com> <527C5D36.7050206@huawei.com> <CAErSpo73N2Th-4D5G8-60tMuGwqthfu-VNHVf3LF9+s2mQp53w@mail.gmail.com>
In-Reply-To: <CAErSpo73N2Th-4D5G8-60tMuGwqthfu-VNHVf3LF9+s2mQp53w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Hmmm, this is the thing I am most worried about. If we just only use
>> (pci_dev *) poninter in drhd->devices array as a identification. Change
>> (pci_dev *) pointer instead of pci device id segment:bus:devfn is safe.
>> Or, this is a wrong way to fix this issue. I don't know IOMMU driver much now,
>> so IOMMU guys any comments on this issue is welcome.
>>
>> If this is not safe, what about we both save pci device id and (pci_dev *) pointer
>> in drhd. So we can put pci_dev ref and set pci_dev * = NULL during device removed by bus notify, and
>> update (pci_dev *)pointer during device add.
> 
> I don't know the IOMMU drivers well either, but it seems like they
> rely on notifications of device addition and removal (see
> iommu_bus_notifier()).  It doesn't seem right for them to also use the
> generic PCI interfaces like pci_get_domain_bus_and_slot() because the
> IOMMU driver should already know what devices exist and their
> lifetimes.  It seems like confusion to mix the two.  But I don't have
> a concrete suggestion.

Maybe you are right~, I will try to rework the patch and resend soon.

Thanks!
Yijing.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> .
> 


-- 
Thanks!
Yijing

