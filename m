Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab3BUBTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 20:19:50 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38655 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3BUBTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 20:19:47 -0500
MIME-Version: 1.0
In-Reply-To: <1360623637.2950.63.camel@lorien2>
References: <1360623637.2950.63.camel@lorien2>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 20 Feb 2013 18:19:27 -0700
Message-ID: <CAErSpo6jY1bX9G59uz8Zt_pDJ4OoR=kJkGjNLYYRTrKVXM8+eg@mail.gmail.com>
Subject: Re: [PATCH 1/4] pci: Add PCI_BUS() and PCI_DEVID() interfaces to
 return bus number and device id
To: shuah.khan@hp.com, dhowells@redhat.com
Cc: Joerg Roedel <joro@8bytes.org>, paulmck@linux.vnet.ibm.com,
        linasvepstas@gmail.com, davej@redhat.com, tglx@linutronix.de,
        mtk.manpages@gmail.com, iommu@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        shemminger@vyatta.com, jiang.liu@huawei.com, wangyijing@huawei.com,
        shuahkhan@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 4:00 PM, Shuah Khan <shuah.khan@hp.com> wrote:
> pci defines PCI_DEVFN(), PCI_SLOT(), and PCI_FUNC() interfaces, however,
> it doesn't have interfaces to return PCI bus and PCI device id. Drivers
> (AMD IOMMU, and AER) implement module specific definitions for PCI_BUS()
> and AMD_IOMMU driver also has a module specific interface to calculate PCI
> device id from bus number and devfn.
>
> Add PCI_BUS and PCI_DEVID interfaces to return PCI bus number and PCI device
> id respectively to avoid the need for duplicate definitions in other modules.
> AER driver code and AMD IOMMU driver define PCI_BUS. AMD IOMMU driver defines
> an interface to calculate device id from bus number, and devfn pair.
>
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  include/uapi/linux/pci.h |    4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/include/uapi/linux/pci.h b/include/uapi/linux/pci.h
> index 3c292bc0..6b2c8b3 100644
> --- a/include/uapi/linux/pci.h
> +++ b/include/uapi/linux/pci.h
> @@ -30,6 +30,10 @@
>  #define PCI_DEVFN(slot, func)  ((((slot) & 0x1f) << 3) | ((func) & 0x07))
>  #define PCI_SLOT(devfn)                (((devfn) >> 3) & 0x1f)
>  #define PCI_FUNC(devfn)                ((devfn) & 0x07)
> +#define PCI_DEVID(bus, devfn)  ((((u16)bus) << 8) | devfn)
> +
> +/* return bus from PCI devid = ((u16)bus_number) << 8) | devfn */
> +#define PCI_BUS(x) (((x) >> 8) & 0xff)
>
>  /* Ioctls for /proc/bus/pci/X/Y nodes. */
>  #define PCIIOC_BASE            ('P' << 24 | 'C' << 16 | 'I' << 8)

David, can you point me at a description of include/uapi ... what is
there and why, and how we should decide what new things go in
include/uapi/linux/pci.h as opposed to include/linux/pci.h?  Maybe
there should be something in Documentation/?

I'm guessing it's something to do with being exported to userland, but
I'm not sure the things in this patch (PCI_DEV_ID, PCI_BUS) are really
exportable in the sense of being used for syscalls, etc.

Bjorn
