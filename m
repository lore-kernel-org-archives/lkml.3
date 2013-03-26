Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab3CZVla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:41:30 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57510 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3CZVl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 17:41:28 -0400
MIME-Version: 1.0
In-Reply-To: <1362009978.2808.33.camel@lorien2>
References: <1362009978.2808.33.camel@lorien2>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 26 Mar 2013 15:41:07 -0600
Message-ID: <CAErSpo6DjjSKCFL6CjmqkOAyc1iU1TG1=n=K=AXPcU_r6ZdPGA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] pci: Add PCI_BUS() and PCI_DEVID() interfaces to
 return bus number and device id
To: shuah.khan@hp.com
Cc: Joerg Roedel <joro@8bytes.org>, Jiang Liu <jiang.liu@huawei.com>,
        "shemminger@vyatta.com" <shemminger@vyatta.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linas Vepstas <linasvepstas@gmail.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        iommu@lists.linux-foundation.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, Shuah Khan <shuahkhan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 5:06 PM, Shuah Khan <shuah.khan@hp.com> wrote:
> pci defines PCI_DEVFN(), PCI_SLOT(), and PCI_FUNC() interfaces, however,
> it doesn't have interfaces to return PCI bus and PCI device id. Drivers
> (AMD IOMMU, and AER) have module specific definitions for PCI_BUS() and
> AMD_IOMMU driver also has a module specific interface to calculate PCI
> device id from bus number and devfn.
>
> This patch set adds PCI_BUS_NUM(), and PCI_DEVID() to pci.h, changes AER
> to use PCI_BUS_NUM() from pci and remove local PCI_BUS() define. Changes
> AMD_IOMMU driver to use PCI_BUS_NUM() and PCI_DEVID() from pci and remove
> local PCI_BUS() define and local PCI_DEVID() implementation.
>
> Files changed:
>
> [PATCH v2 1/4] pci: Add PCI_BUS_NUM() and PCI_DEVID() interfaces to return bus
>            number and device id
>
>  include/linux/pci.h |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> [PATCH v2 2/4] pci/aer: Remove local PCI_BUS() define and use PCI_BUS_NUM()
>            from pci
>
>  drivers/pci/pcie/aer/aerdrv_core.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> [PATCH v2 3/4] iommu/amd: Remove local PCI_BUS() define and use PCI_BUS_NUM()
>            from pci
>
>  drivers/iommu/amd_iommu.c       |   12 ++++++------
>  drivers/iommu/amd_iommu_init.c  |   34 +++++++++++++++++-----------------
>  drivers/iommu/amd_iommu_types.h |    4 +---
>  3 files changed, 24 insertions(+), 26 deletions(-)
>
> [PATCH v2 4/4] iommu/amd: Remove calc_devid() and use PCI_DEVID() from pci
> (no change to this patch - but tagging it v2 for clarity)
>
>  drivers/iommu/amd_iommu.c       |    2 +-
>  drivers/iommu/amd_iommu_init.c  |    6 +++---
>  drivers/iommu/amd_iommu_types.h |    7 -------
>  3 files changed, 4 insertions(+), 11 deletions(-)

Thanks, Shuah, I applied these to a pci/shuah-defines branch and pushed it.

Since some of these touch drivers/iommu, it'd be good if you acked
them again, Joerg.  I know you acked them before, but there have been
minor changes since then, so I didn't add your ack to these.  But if
you're still OK with them, I'll refresh the branch to add it now.

Bjorn
