Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab3FGPa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:30:27 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:61894 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab3FGPaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:30:21 -0400
Message-ID: <51B1FC83.7090402@gmail.com>
Date: Fri, 07 Jun 2013 23:30:11 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v3, part1 04/10] PCI: mark pci_scan_bus_parented() as
 __deprecated
References: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com> <1369489718-25869-5-git-send-email-jiang.liu@huawei.com> <CAErSpo5bysp-s-twUWgZEyJD01skjW=vXkcQBYkn_TALP83r1g@mail.gmail.com> <51B0B99C.4020009@gmail.com> <20130607143758.GA13427@phenom.dumpdata.com>
In-Reply-To: <20130607143758.GA13427@phenom.dumpdata.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 10:37 PM, Konrad Rzeszutek Wilk wrote:
> On Fri, Jun 07, 2013 at 12:32:28AM +0800, Jiang Liu wrote:
>> On Thu 06 Jun 2013 04:04:36 AM CST, Bjorn Helgaas wrote:
>>> [+cc Konrad, Jeremy, xen-devel (users of interface you're deprecating)]
>>>
>>> On Sat, May 25, 2013 at 7:48 AM, Jiang Liu <liuj97@gmail.com> wrote:
>>>> Mark pci_scan_bus_parented() as __deprecated and clean up outdated
>>>> comments.
>>>>
>>>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>>>> Cc: Chris Metcalf <cmetcalf@tilera.com>
>>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>> Cc: Thierry Reding <thierry.reding@avionic-design.de>
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Cc: linux-pci@vger.kernel.org
>>>> ---
>>>>  arch/tile/kernel/pci.c | 3 ---
>>>>  include/linux/pci.h    | 4 ++--
>>>>  2 files changed, 2 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
>>>> index 67237d3..936e087 100644
>>>> --- a/arch/tile/kernel/pci.c
>>>> +++ b/arch/tile/kernel/pci.c
>>>> @@ -309,9 +309,6 @@ int __init pcibios_init(void)
>>>>                          *
>>>>                          * It reads the PCI tree for this bus into the Linux
>>>>                          * data structures.
>>>> -                        *
>>>> -                        * This is inlined in linux/pci.h and calls into
>>>> -                        * pci_scan_bus_parented() in probe.c.
>>>>                          */
>>>>                         pci_add_resource(&resources, &ioport_resource);
>>>>                         pci_add_resource(&resources, &iomem_resource);
>>>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>>>> index b0f4a82..7b23fa0 100644
>>>> --- a/include/linux/pci.h
>>>> +++ b/include/linux/pci.h
>>>> @@ -720,8 +720,8 @@ void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
>>>>  void pcibios_scan_specific_bus(int busn);
>>>>  struct pci_bus *pci_find_bus(int domain, int busnr);
>>>>  void pci_bus_add_devices(const struct pci_bus *bus);
>>>> -struct pci_bus *pci_scan_bus_parented(struct device *parent, int bus,
>>>> -                                     struct pci_ops *ops, void *sysdata);
>>>> +struct pci_bus * __deprecated pci_scan_bus_parented(struct device *parent,
>>>> +                       int bus, struct pci_ops *ops, void *sysdata);
>>>>  struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *sysdata);
>>>>  struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>>>>                                     struct pci_ops *ops, void *sysdata,
>>>
>>> I think this patch is a good idea, but I think we need to change the
>>> only existing user of pci_scan_bus_parented() (pcifront_scan_root() in
>>> drivers/pci/xen-pcifront.c) at the same time, so xen doesn't start
>>> getting build warnings.  The deprecation warnings are really intended
>>> for out-of-tree users that we aren't able to fix ourselves.
>>>
>>> I'm getting this series queued up in
>>> http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/jiang-bus-lock-v3,
>>> so if you want to send a patch just for xen, I can fold that in.
>>>
>>> Bjorn
>> Hi Bjorn,
>>         I have posted a big patch for that, but still need help from 
>> Xen experts to review it.
>> Please refer to https://patchwork.kernel.org/patch/2578551/
> 
> Hm, I seem to get:
> 
> /home/konrad/linux/drivers/pci/xen-pcifront.c: In function ‘pcifront_free_roots’:
> /home/konrad/linux/drivers/pci/xen-pcifront.c:559: error: implicit declaration of function ‘for_each_pci_root_bus’
> /home/konrad/linux/drivers/pci/xen-pcifront.c:559: error: expected ‘;’ before ‘{’ token
> /home/konrad/linux/drivers/pci/xen-pcifront.c:554: warning: unused variable ‘sd’
> 
> with it? Is there an up-to-date patch?
> I have these in my tree:
> 
> 311db40 PCI, xen-pcifront: use new PCI interfaces to simplify implementation
> 4079fee Merge remote-tracking branch 'bjorn/pci/jiang-bus-lock-v3' into testing
> ddb7c6b PCI: Hide remove and rescan sysfs interfaces for SR-IOV virtual functions
> f5cfa3a PCI: Simplify IOV implementation and fix reference count races
> 28b4f07 PCI: Drop redundant setting of bus->is_added in virtfn_add_bus()
> 442655a unicore32/PCI: Remove redundant call of pci_bus_add_devices()
> defd601 m68k/PCI: Remove redundant call of pci_bus_add_devices()
> 340e3fb PCI: Make PCI host bridge/bus creating and destroying logic symmetric
> c7025f7 ia64/PCI: Clean up pci_scan_root_bus() usage
> c1f41ce PCI: Mark pci_scan_bus_parented() as __deprecated
> 13e5057 PCI: Convert alloc_pci_dev(void) to pci_alloc_dev(bus)
> 007042a PCI: Introduce pci_alloc_dev(struct pci_bus*) to replace alloc_pci_dev()
> fe830ef PCI: Introduce pci_bus_{get|put}() to manage PCI bus reference count
Hi Konrad,
   Could you please help to apply this simple patch onto to your tree?
It should fix the build failure issue.

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 79ad229..b5e0e66 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -556,7 +556,7 @@ static void pcifront_free_roots(struct
pcifront_device *pdev)

        dev_dbg(&pdev->xdev->dev, "cleaning up root buses\n");

-       for_each_pci_root_bus(bus) {
+       list_for_each_entry(bus, &pci_root_buses, node) {
                sd = bus->sysdata;
                if (sd->pdev == pdev) {
                        pci_stop_root_bus(bus);



> 
> Also oddly enough your SoB does not match your Author. Here is
> what git shows:
> 
> === > Author: Jiang Liu <liuj97@gmail.com>  2013-05-25 09:48:38
>     
> === > Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> 
> You can add in the gmail an new 'email alias' so that the emails will
> look as they come from your huawei address.
> 

