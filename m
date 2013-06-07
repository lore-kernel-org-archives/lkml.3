Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab3FGOir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:38:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21322 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3FGOip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:38:45 -0400
Date: Fri, 7 Jun 2013 10:37:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
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
Message-ID: <20130607143758.GA13427@phenom.dumpdata.com>
References: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com>
 <1369489718-25869-5-git-send-email-jiang.liu@huawei.com>
 <CAErSpo5bysp-s-twUWgZEyJD01skjW=vXkcQBYkn_TALP83r1g@mail.gmail.com>
 <51B0B99C.4020009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51B0B99C.4020009@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 12:32:28AM +0800, Jiang Liu wrote:
> On Thu 06 Jun 2013 04:04:36 AM CST, Bjorn Helgaas wrote:
> > [+cc Konrad, Jeremy, xen-devel (users of interface you're deprecating)]
> >
> > On Sat, May 25, 2013 at 7:48 AM, Jiang Liu <liuj97@gmail.com> wrote:
> >> Mark pci_scan_bus_parented() as __deprecated and clean up outdated
> >> comments.
> >>
> >> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> >> Cc: Chris Metcalf <cmetcalf@tilera.com>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> >> Cc: linux-kernel@vger.kernel.org
> >> Cc: linux-pci@vger.kernel.org
> >> ---
> >>  arch/tile/kernel/pci.c | 3 ---
> >>  include/linux/pci.h    | 4 ++--
> >>  2 files changed, 2 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
> >> index 67237d3..936e087 100644
> >> --- a/arch/tile/kernel/pci.c
> >> +++ b/arch/tile/kernel/pci.c
> >> @@ -309,9 +309,6 @@ int __init pcibios_init(void)
> >>                          *
> >>                          * It reads the PCI tree for this bus into the Linux
> >>                          * data structures.
> >> -                        *
> >> -                        * This is inlined in linux/pci.h and calls into
> >> -                        * pci_scan_bus_parented() in probe.c.
> >>                          */
> >>                         pci_add_resource(&resources, &ioport_resource);
> >>                         pci_add_resource(&resources, &iomem_resource);
> >> diff --git a/include/linux/pci.h b/include/linux/pci.h
> >> index b0f4a82..7b23fa0 100644
> >> --- a/include/linux/pci.h
> >> +++ b/include/linux/pci.h
> >> @@ -720,8 +720,8 @@ void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
> >>  void pcibios_scan_specific_bus(int busn);
> >>  struct pci_bus *pci_find_bus(int domain, int busnr);
> >>  void pci_bus_add_devices(const struct pci_bus *bus);
> >> -struct pci_bus *pci_scan_bus_parented(struct device *parent, int bus,
> >> -                                     struct pci_ops *ops, void *sysdata);
> >> +struct pci_bus * __deprecated pci_scan_bus_parented(struct device *parent,
> >> +                       int bus, struct pci_ops *ops, void *sysdata);
> >>  struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *sysdata);
> >>  struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
> >>                                     struct pci_ops *ops, void *sysdata,
> >
> > I think this patch is a good idea, but I think we need to change the
> > only existing user of pci_scan_bus_parented() (pcifront_scan_root() in
> > drivers/pci/xen-pcifront.c) at the same time, so xen doesn't start
> > getting build warnings.  The deprecation warnings are really intended
> > for out-of-tree users that we aren't able to fix ourselves.
> >
> > I'm getting this series queued up in
> > http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/jiang-bus-lock-v3,
> > so if you want to send a patch just for xen, I can fold that in.
> >
> > Bjorn
> Hi Bjorn,
>         I have posted a big patch for that, but still need help from 
> Xen experts to review it.
> Please refer to https://patchwork.kernel.org/patch/2578551/

Hm, I seem to get:

/home/konrad/linux/drivers/pci/xen-pcifront.c: In function ‘pcifront_free_roots’:
/home/konrad/linux/drivers/pci/xen-pcifront.c:559: error: implicit declaration of function ‘for_each_pci_root_bus’
/home/konrad/linux/drivers/pci/xen-pcifront.c:559: error: expected ‘;’ before ‘{’ token
/home/konrad/linux/drivers/pci/xen-pcifront.c:554: warning: unused variable ‘sd’

with it? Is there an up-to-date patch?
I have these in my tree:

311db40 PCI, xen-pcifront: use new PCI interfaces to simplify implementation
4079fee Merge remote-tracking branch 'bjorn/pci/jiang-bus-lock-v3' into testing
ddb7c6b PCI: Hide remove and rescan sysfs interfaces for SR-IOV virtual functions
f5cfa3a PCI: Simplify IOV implementation and fix reference count races
28b4f07 PCI: Drop redundant setting of bus->is_added in virtfn_add_bus()
442655a unicore32/PCI: Remove redundant call of pci_bus_add_devices()
defd601 m68k/PCI: Remove redundant call of pci_bus_add_devices()
340e3fb PCI: Make PCI host bridge/bus creating and destroying logic symmetric
c7025f7 ia64/PCI: Clean up pci_scan_root_bus() usage
c1f41ce PCI: Mark pci_scan_bus_parented() as __deprecated
13e5057 PCI: Convert alloc_pci_dev(void) to pci_alloc_dev(bus)
007042a PCI: Introduce pci_alloc_dev(struct pci_bus*) to replace alloc_pci_dev()
fe830ef PCI: Introduce pci_bus_{get|put}() to manage PCI bus reference count

Also oddly enough your SoB does not match your Author. Here is
what git shows:

=== > Author: Jiang Liu <liuj97@gmail.com>  2013-05-25 09:48:38
    
=== > Signed-off-by: Jiang Liu <jiang.liu@huawei.com>

You can add in the gmail an new 'email alias' so that the emails will
look as they come from your huawei address.
