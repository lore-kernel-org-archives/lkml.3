Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbaFLBS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 21:18:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:7783 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbaFLBS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 21:18:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,461,1400050800"; 
   d="scan'208";a="527143781"
Message-ID: <5398FFDA.5050601@linux.intel.com>
Date: Thu, 12 Jun 2014 09:18:18 +0800
From: baolu <baolu.lu@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Mathias Nyman <mathias.nyman@intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] xhci: clear root port wake on bits if controller
 isn't wake-up capable
References: <1402439120-78151-1-git-send-email-baolu.lu@linux.intel.com> <20140611152604.GA27630@kroah.com>
In-Reply-To: <20140611152604.GA27630@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06/11/2014 11:26 PM, Greg Kroah-Hartman wrote:
> On Wed, Jun 11, 2014 at 06:25:20AM +0800, Lu Baolu wrote:
>> When the xHCI PCI host is suspended, if do_wakeup is false in xhci_pci_suspend,
>> xhci_bus_suspend needs to clear all root port wake on bits. Otherwise some Intel
>> platform may get a spurious wakeup, even if PCI PME# is disabled.
>>
>> http://marc.info/?l=linux-usb&m=138194006009255&w=2
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/usb/host/xhci-hub.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
> Should this also be a stable kernel patch?  If so, how far back?
Yes.

This patch should be back-ported to kernels as old as 2.6.37, that
contains the commit 9777e3ce907d4cb5a513902a87ecd03b52499569
"USB: xHCI: bus power management implementation".

Thanks,
-baolu
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

