Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaFDS5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:57:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaFDS5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:57:43 -0400
Date: Wed, 4 Jun 2014 12:01:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ritesh Harjani <ritesh.harjani@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] device.h: arm,dma-iommu: Move out dma_iommu_mapping
 struct
Message-ID: <20140604190123.GC30884@kroah.com>
References: <1401869506-48129-1-git-send-email-ritesh.harjani@gmail.com>
 <1401869506-48129-2-git-send-email-ritesh.harjani@gmail.com>
 <20140604175145.GD20812@kroah.com>
 <CAD15agbiuXiiAp62R-NeLeX3rgNftmyb+wGiSVx-FgtcXzxpHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD15agbiuXiiAp62R-NeLeX3rgNftmyb+wGiSVx-FgtcXzxpHA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 12:16:28AM +0530, Ritesh Harjani wrote:
> >> --- a/include/linux/device.h
> >> +++ b/include/linux/device.h
> >> @@ -705,6 +705,10 @@ struct device {
> >>       /* arch specific additions */
> >>       struct dev_archdata     archdata;
> >>
> >> +#ifdef CONFIG_DMA_USE_IOMMU_HELPER_MAPPING
> >> +     struct dma_iommu_mapping        *mapping;
> >> +#endif
> >> +
> >>       struct device_node      *of_node; /* associated device tree node */
> >>       struct acpi_dev_node    acpi_node; /* associated ACPI device node */
> >>
> >
> > Are you sure this will not break the build on systems that enable that
> > option, yet do not include iommu-helper.h?
> 
> They need to include iommu-helper.h wherever they are using this
> structure members. Until then no this should
> not break the build I think for the case you mentioned.

Try it and find out :)

> That's how it was done in arch/arm/include/asm/device.h

Perhaps something else was pulling in that .h file?  device.h is used
_everywhere_ you can not assume someone will have included another .h
file before it.

> Do I need to do this in diff way ?

Yes, just predefine the structure in the .h file.

And do you really need the #ifdef?

thanks,

greg k-h
