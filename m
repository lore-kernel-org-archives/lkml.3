Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3FFQcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:32:39 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:43677 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab3FFQch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:32:37 -0400
Message-ID: <51B0B99C.4020009@gmail.com>
Date: Fri, 07 Jun 2013 00:32:28 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v3, part1 04/10] PCI: mark pci_scan_bus_parented() as
 __deprecated
References: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com> <1369489718-25869-5-git-send-email-jiang.liu@huawei.com> <CAErSpo5bysp-s-twUWgZEyJD01skjW=vXkcQBYkn_TALP83r1g@mail.gmail.com>
In-Reply-To: <CAErSpo5bysp-s-twUWgZEyJD01skjW=vXkcQBYkn_TALP83r1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 06 Jun 2013 04:04:36 AM CST, Bjorn Helgaas wrote:
> [+cc Konrad, Jeremy, xen-devel (users of interface you're deprecating)]
>
> On Sat, May 25, 2013 at 7:48 AM, Jiang Liu <liuj97@gmail.com> wrote:
>> Mark pci_scan_bus_parented() as __deprecated and clean up outdated
>> comments.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Cc: Chris Metcalf <cmetcalf@tilera.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Thierry Reding <thierry.reding@avionic-design.de>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-pci@vger.kernel.org
>> ---
>>  arch/tile/kernel/pci.c | 3 ---
>>  include/linux/pci.h    | 4 ++--
>>  2 files changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
>> index 67237d3..936e087 100644
>> --- a/arch/tile/kernel/pci.c
>> +++ b/arch/tile/kernel/pci.c
>> @@ -309,9 +309,6 @@ int __init pcibios_init(void)
>>                          *
>>                          * It reads the PCI tree for this bus into the Linux
>>                          * data structures.
>> -                        *
>> -                        * This is inlined in linux/pci.h and calls into
>> -                        * pci_scan_bus_parented() in probe.c.
>>                          */
>>                         pci_add_resource(&resources, &ioport_resource);
>>                         pci_add_resource(&resources, &iomem_resource);
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index b0f4a82..7b23fa0 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -720,8 +720,8 @@ void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
>>  void pcibios_scan_specific_bus(int busn);
>>  struct pci_bus *pci_find_bus(int domain, int busnr);
>>  void pci_bus_add_devices(const struct pci_bus *bus);
>> -struct pci_bus *pci_scan_bus_parented(struct device *parent, int bus,
>> -                                     struct pci_ops *ops, void *sysdata);
>> +struct pci_bus * __deprecated pci_scan_bus_parented(struct device *parent,
>> +                       int bus, struct pci_ops *ops, void *sysdata);
>>  struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *sysdata);
>>  struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>>                                     struct pci_ops *ops, void *sysdata,
>
> I think this patch is a good idea, but I think we need to change the
> only existing user of pci_scan_bus_parented() (pcifront_scan_root() in
> drivers/pci/xen-pcifront.c) at the same time, so xen doesn't start
> getting build warnings.  The deprecation warnings are really intended
> for out-of-tree users that we aren't able to fix ourselves.
>
> I'm getting this series queued up in
> http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/jiang-bus-lock-v3,
> so if you want to send a patch just for xen, I can fold that in.
>
> Bjorn
Hi Bjorn,
        I have posted a big patch for that, but still need help from 
Xen experts to review it.
Please refer to https://patchwork.kernel.org/patch/2578551/
Thanks!
Gerry
