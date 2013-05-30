Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967611Ab3E3G1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 02:27:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:63405 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966921Ab3E3G1D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 02:27:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,769,1363158000"; 
   d="scan'208";a="342373831"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: Yinghai Lu <yinghai@kernel.org>, Yijing Wang <wangyijing@huawei.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] PCI: set correct value for iov device before device
Thread-Topic: [PATCH] PCI: set correct value for iov device before device
Thread-Index: AQHOXPj93z4//Pk0rk6Egvj8nMkloJkctyqAgACJ2XA=
Date: Thu, 30 May 2013 06:26:55 +0000
Message-ID: <403610A45A2B5242BD291EDAE8B37D3010E40DB8@SHSMSX152.ccr.corp.intel.com>
References: <1369892734-26244-1-git-send-email-xudong.hao@intel.com>
 <CAE9FiQUCOJ5FFwRWpVy59RqEwGC2KMNXvKe5HUAKLSES5fAR+Q@mail.gmail.com>
In-Reply-To: <CAE9FiQUCOJ5FFwRWpVy59RqEwGC2KMNXvKe5HUAKLSES5fAR+Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, I saw patch in PCI tree two days ago by Jiang Liu.

Thanks,
-Xudong


> -----Original Message-----
> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
> Yinghai Lu
> Sent: Thursday, May 30, 2013 2:05 PM
> To: Hao, Xudong
> Cc: Bjorn Helgaas; linux-pci@vger.kernel.org; Linux Kernel Mailing List
> Subject: Re: [PATCH] PCI: set correct value for iov device before device
> 
> On Wed, May 29, 2013 at 10:45 PM, Xudong Hao <xudong.hao@intel.com>
> wrote:
> > Since device registering is put into pci_device_add(), it must set value of
> > Virtual Function device's member before the pci_dev is put to device tree. Or
> > some relevant subsystem of driver model such as xen will report a incorrect
> > IOV device to Xen hypervior.
> >
> > Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> > ---
> >  drivers/pci/iov.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> > index c93071d..43d3de9 100644
> > --- a/drivers/pci/iov.c
> > +++ b/drivers/pci/iov.c
> > @@ -110,12 +110,12 @@ static int virtfn_add(struct pci_dev *dev, int id, int
> reset)
> >         if (reset)
> >                 __pci_reset_function(virtfn);
> >
> > -       pci_device_add(virtfn, virtfn->bus);
> > -       mutex_unlock(&iov->dev->sriov->lock);
> > -
> >         virtfn->physfn = pci_dev_get(dev);
> >         virtfn->is_virtfn = 1;
> >
> > +       pci_device_add(virtfn, virtfn->bus);
> > +       mutex_unlock(&iov->dev->sriov->lock);
> > +
> >         rc = pci_bus_add_device(virtfn);
> >         sprintf(buf, "virtfn%u", id);
> >         rc = sysfs_create_link(&dev->dev.kobj, &virtfn->dev.kobj, buf);
> 
> I have similar patch at
> https://patchwork.kernel.org/patch/2562551/
>    [5/7] PCI, ACPI: Don't glue ACPI dev with pci VFs
> 
> and Jiang has another one
> https://patchwork.kernel.org/patch/2613481/
>    [v3,part1,10/10] PCI, IOV: hide remove and rescan sysfs interfaces
> for SR-IOV virtual functions
> 
> Thanks
> 
> Yinghai
