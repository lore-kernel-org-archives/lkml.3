Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbbAZJ6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:58:05 -0500
Received: from service87.mimecast.com ([91.220.42.44]:48649 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbbAZJ6B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:58:01 -0500
Date: Mon, 26 Jan 2015 09:57:57 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [RFC PATCH v3 2/2] arm: kernel: fix pci_mmap_page_range() offset
 calculation
Message-ID: <20150126095757.GB23384@e102568-lin.cambridge.arm.com>
References: <1415877558-8906-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1415877558-8906-3-git-send-email-lorenzo.pieralisi@arm.com>
 <20150123235911.GG13072@google.com>
MIME-Version: 1.0
In-Reply-To: <20150123235911.GG13072@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 26 Jan 2015 09:57:58.0311 (UTC) FILETIME=[90310B70:01D0394E]
X-MC-Unique: 115012609575900301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 11:59:11PM +0000, Bjorn Helgaas wrote:
> On Thu, Nov 13, 2014 at 11:19:16AM +0000, Lorenzo Pieralisi wrote:
> > The pci_mmap_page_range() API should be written to expect offset
> > values representing PCI memory resource addresses as seen by user
> > space, through the pci_resource_to_user() API.
> > 
> > ARM relies on the standard implementation of pci_resource_to_user()
> > which actually is an identity map and exports to user space
> > PCI memory resources as they are stored in PCI devices resources
> > structures, which represent CPU physical addresses (fixed-up using
> > BUS to CPU address conversions) not PCI bus addresses.
> > 
> > Therefore, on ARM platforms where the mapping between CPU and BUS
> > address is not a 1:1 the current pci_mmap_page_range() implementation is
> > erroneous, in that an additional shift is applied to an already fixed-up
> > offset passed from userspace.
> > 
> > Hence, this patch removes the mem_offset from the pgoff calculation
> > since the offset as passed from user space already represents the CPU
> > physical address corresponding to the resource to be mapped, ie no
> > additional offset should be applied.
> > 
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Thank you, I will ask Russell to merge it.

Lorenzo

