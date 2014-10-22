Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbaJVPn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:43:27 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:51761 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaJVPnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:43:25 -0400
Date: Wed, 22 Oct 2014 17:43:20 +0200
From: Frank Blaschka <blaschka@linux.vnet.ibm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        sebott@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com
Subject: Re: [PATCH linux-next] iommu: add iommu for s390 platform
Message-ID: <20141022154320.GA42442@tuxmaker.boeblingen.de.ibm.com>
References: <1413892645-37657-1-git-send-email-blaschka@linux.vnet.ibm.com> <20141022141728.GG10074@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022141728.GG10074@8bytes.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102215-0017-0000-0000-0000018C4046
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 04:17:29PM +0200, Joerg Roedel wrote:
> Hi Frank,
> 
> On Tue, Oct 21, 2014 at 01:57:25PM +0200, Frank Blaschka wrote:
> > Add a basic iommu for the s390 platform. The code is pretty simple
> > since on s390 each PCI device has its own virtual io address space
> > starting at the same vio address.
> 
> Are there any limitations on IOVA address space for the devices or can
> be really any system physical address mapped starting from 0 to 2^64?
>

Hi Joerg,

Basically there are no limitations. Depending on the s390 maschine
generation a device starts its IOVA at a specific address (announced by
the HW). But as I already told each device starts at the same address.
I think this prevents having multiple devices on the same IOMMU domain.
 
> > For this a domain could hold only one pci device.
> 
> This bothers me, as it is not compatible with the IOMMU-API. I looked a
> little bit into how the mappings are created, and it seems there is a
> per-device dma_table.
>

yes, you are absolutely right. There is a per-device dma_table.
There is no general IOMMU device but each pci device has its own IOMMU
translation capability.
 
> Is there any reason a dma_table can't be per IOMMU domain and assigned
> to multiple devices at the same time?

Is there a possibility the IOMMU domain can support e.g. something like

VIOA 0x10000 -> pci device 1
VIOA 0x10000 -> pci device 2

> 
> Otherwise the code looks quite simple and straight forward.
>

Thx for your review and help 

Frank
 
> 
> 	Joerg
> 
> 

