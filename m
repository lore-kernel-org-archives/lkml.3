Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaDYKgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:36:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:1599 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbaDYKgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:36:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,926,1389772800"; 
   d="scan'208";a="528218750"
Message-ID: <535A3D6D.8020008@linux.intel.com>
Date: Fri, 25 Apr 2014 13:48:13 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@redhat.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/5] xhci: Use pci_enable_msix_exact() instead of pci_enable_msix()
References: <1398169382-12097-1-git-send-email-mathias.nyman@linux.intel.com> <1398169382-12097-3-git-send-email-mathias.nyman@linux.intel.com> <20140424194926.GB12809@kroah.com>
In-Reply-To: <20140424194926.GB12809@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 10:49 PM, Greg KH wrote:
> On Tue, Apr 22, 2014 at 03:22:59PM +0300, Mathias Nyman wrote:
>> From: Alexander Gordeev <agordeev@redhat.com>
>>
>> As result of deprecation of MSI-X/MSI enablement functions
>> pci_enable_msix() and pci_enable_msi_block() all drivers
>> using these two interfaces need to be updated to use the
>> new pci_enable_msi_range()  or pci_enable_msi_exact()
>> and pci_enable_msix_range() or pci_enable_msix_exact()
>> interfaces.
>>
>> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
>> Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: linux-usb@vger.kernel.org
>> Cc: linux-pci@vger.kernel.org
>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>> ---
>>   drivers/usb/host/xhci.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
>> index 988ed5f..b0b8399 100644
>> --- a/drivers/usb/host/xhci.c
>> +++ b/drivers/usb/host/xhci.c
>> @@ -291,7 +291,7 @@ static int xhci_setup_msix(struct xhci_hcd *xhci)
>>   		xhci->msix_entries[i].vector = 0;
>>   	}
>>
>> -	ret = pci_enable_msix(pdev, xhci->msix_entries, xhci->msix_count);
>> +	ret = pci_enable_msix_exact(pdev, xhci->msix_entries, xhci->msix_count);
>
> Why is this change needed for 3.15-final?
>

Can't remember why I thought this was needed for 3.15
Looks like other subsystems (like PCI) just queued similar MSI changes 
for 3.16.

I'll move it to the patchseries for usb-next

-Mathias
