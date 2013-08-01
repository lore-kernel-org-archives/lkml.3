Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab3HANUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:20:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab3HANUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:20:52 -0400
Date: Thu, 1 Aug 2013 09:20:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: bhelgaas@google.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        kexec@lists.infradead.org, ishii.hironobu@jp.fujitsu.com,
        ddutile@redhat.com, bill.sumner@hp.com, alex.williamson@redhat.com,
        hbabu@us.ibm.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] PCI: Reset PCIe devices to stop ongoing DMA
Message-ID: <20130801132017.GA15235@redhat.com>
References: <1368509365-2260-1-git-send-email-indou.takao@jp.fujitsu.com>
 <51F85BCC.2070103@jp.fujitsu.com>
 <CAErSpo4yJ2yqCWv7GT7jWSVd_8SktU=xJXT78m8Vxp_wLA4Fow@mail.gmail.com>
 <1699397.FXoFYIGzbk@vostro.rjw.lan>
 <51FA015E.10901@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FA015E.10901@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 03:34:06PM +0900, Takao Indoh wrote:
> (2013/08/01 6:23), Rafael J. Wysocki wrote:
> > On Wednesday, July 31, 2013 03:08:03 PM Bjorn Helgaas wrote:
> >> [+cc Rafael, linux-acpi]
> >>
> >> On Tue, Jul 30, 2013 at 6:35 PM, Takao Indoh <indou.takao@jp.fujitsu.com> wrote:
> >>
> >>> On x86, currently IOMMU initialization run *after* PCI enumeration, but
> >>> what you are talking about is that it should be changed so that x86
> >>> IOMMU initialization is done *before* PCI enumeration like sparc, right?
> >>
> >> Yes.  I don't know whether or when that initialization order will ever
> >> be changed, but I do think we should avoid building more
> >> infrastructure that depends on the current order.
> >>
> >> Changing the order is a pretty big deal because it's a lot more than
> >> just the IOMMU.  Basically I think we should be enumerating ACPI
> >> devices, including the IOMMU, before PCI devices, but there's a lot of
> >> legacy involved in that area.  Added Rafael in case he has any
> >> thoughts.
> > 
> > Well, actually, I'm not really familiar with IOMMUs, sorry.
> > 
> > I do think that initializing IOMMU before PCI enumeration would be better,
> > however.  At least if the ordering should be the same on all architectures,
> > which I suppose is the case, that's the one I'd choose.
> 
> Ok guys. If x86 IOMMU maintainer also thinks changing order is
> necessary, maybe I need to give up device reset in kdump kernel and
> consider doing it in panic kernel.

I don't think trying to reset all the devices in panic kernel is
a good idea.

We need to handle the problem at IOMMU level first which is 
independent of whether devices have been reset or not.

IOW, we should have the capability to initialize IOMMU first
and be able to deal with devices which are doing DMA.

I am not against doing device reset and it most likely is a good thing
but it should happen in second kernel and not in crashed kernel.

Thanks
Vivek
