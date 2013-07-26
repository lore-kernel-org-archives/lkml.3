Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab3GZI0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 04:26:33 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:55435 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3GZI02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 04:26:28 -0400
Message-ID: <51F2328F.4050500@huawei.com>
Date: Fri, 26 Jul 2013 16:25:51 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>, Paul Bolle <pebolle@tiscali.nl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <jiang.liu@huawei.com>, Oliver Neukum <oneukum@suse.de>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH -v3 3/3] PCI,pciehp: use PCIe DSN to identify device change
 during suspend
References: <1373621543-54836-1-git-send-email-wangyijing@huawei.com> <1373621543-54836-4-git-send-email-wangyijing@huawei.com> <CAErSpo4XhONYq3CZnPKgdMD4V5o8fgFc=NGVUGgFz0y5zM3GyA@mail.gmail.com>
In-Reply-To: <CAErSpo4XhONYq3CZnPKgdMD4V5o8fgFc=NGVUGgFz0y5zM3GyA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,
   Thanks for your review and comments!

> 
> I'm not sure this is implemented at the correct place.  The idea of
> using the serial number to detect card swaps is not really specific to
> pciehp.  I know the Device Serial Number capability is defined in the
> PCIe spec, but it doesn't *require* any PCIe functionality, and
> there's no reason a similar capability couldn't be defined for
> conventional PCI.

Yes, maybe implement this interface in PCI core is better.

> 
> I don't know much about it, but conventional PCI *does* in fact
> support the VPD capability, which can contain a serial number.  I
> wonder if we should enhance pci_device_serial_number() to look for a
> VPD serial number if there's no PCIe DSN.  Then we would want this
> check for card swap in a more generic place, e.g., somewhere in
> pci_scan_slot(), so all forms of hotplug would benefit from it.

This is a good idea, I will try to enhance pci_device_serial_number to
support legacy PCI device VPD capability. Then I will try to move this to
a more generic place.

> 
> Also, I think it's possible to use acpiphp for ExpressCard slots, and
> this patch doesn't help acpiphp detect card swaps.  I don't see any
> mention of suspend/resume in acpiphp, so I don't know if it does
> anything at all to detect card changes while suspended.  Maybe Rafael
> can shed some light?

Acpiphp driver is not attached to a specific pci/pcie device, so i think
there is no point to call driver->suspend/resume interface.
Add cc Rafael J. Wysocki.

> 
> I put the first two patches on a pci/yijing-dsn-v3 branch while we
> work out the details of this one.

Thanks!

> 
> Bjorn
> 
>>         } else if (!list_empty(&pbus->devices)) {
>>                 pciehp_disable_slot(slot);
>>         }
>> --
>> 1.7.1
>>
>>
> 
> .
> 


-- 
Thanks!
Yijing

