Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaG2Bxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 21:53:51 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28278 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaG2Bxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 21:53:48 -0400
Message-ID: <53D6FE95.6040605@oracle.com>
Date: Tue, 29 Jul 2014 09:53:25 +0800
From: ethan zhao <ethan.zhao@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, alexander.h.duyck@intel.com,
        ethan.kernel@gmail.com
Subject: Re: [PATCH 1/4] PCI: introduce helper functions for device flag operation
References: <1406045944-1587-1-git-send-email-ethan.zhao@oracle.com>  <1406045944-1587-2-git-send-email-ethan.zhao@oracle.com> <1406581206.1011.133.camel@ul30vt.home>
In-Reply-To: <1406581206.1011.133.camel@ul30vt.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014/7/29 5:00, Alex Williamson wrote:
> On Wed, 2014-07-23 at 00:19 +0800, Ethan Zhao wrote:
>> This patch introduced three helper functions to hide direct
>> device flag operation.
>>
>> void pci_set_dev_assigned(struct pci_dev *pdev);
>> void pci_set_dev_deassigned(struct pci_dev *pdev);
>> bool pci_is_dev_assigned(struct pci_dev *pdev);
>>
>> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
>> ---
>>   include/linux/pci.h |   13 +++++++++++++
>>   1 files changed, 13 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index aab57b4..5f6f8fa 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -1129,6 +1129,19 @@ resource_size_t pcibios_window_alignment(struct pci_bus *bus,
>>   
>>   int pci_set_vga_state(struct pci_dev *pdev, bool decode,
>>   		      unsigned int command_bits, u32 flags);
>> +/* helper functions for operation of device flag */
>> +static inline void pci_set_dev_assigned(struct pci_dev *pdev)
>> +{
>> +	pdev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
>> +}
>> +static inline void pci_set_dev_deassigned(struct pci_dev *pdev)
>> +{
>> +	pdev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
>> +}
> I think pci_clear_dev_assigned() would make more sense, we're not
> setting a flag named DEASSIGNED.
   Though it is a flag operation now, may not later, we define it 
because we want to hide the internal operation.
   'set' to 'deassigned'  status is enough. So I would like keep it.
>
>> +static inline bool pci_is_dev_assigned(struct pci_dev *pdev)
>> +{
>> +	return pdev->dev_flags & PCI_DEV_FLAGS_ASSIGNED ? true : false;
>> +}
> The ternary operation isn't necessary.  Thanks,
   Yep,

   return pdev->dev_flags & PCI_DEV_FLAGS_ASSIGNED

   is enough.

   Thanks,
   Ethan
>
> Alex
>
>>   /* kmem_cache style wrapper around pci_alloc_consistent() */
>>   
>>   #include <linux/pci-dma.h>
>
>

