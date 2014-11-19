Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbaKSJ5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:57:12 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33066 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaKSJ5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:57:09 -0500
Date: Wed, 19 Nov 2014 09:57:01 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <monstr@monstr.eu>,
        Martin Wilck <martin.wilck@ts.fujitsu.com>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [RFC PATCH v3 0/2] Fix procfs PCI resources mmap
Message-ID: <20141119095701.GB8751@red-moon>
References: <1415877558-8906-1-git-send-email-lorenzo.pieralisi@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415877558-8906-1-git-send-email-lorenzo.pieralisi@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 11:19:14AM +0000, Lorenzo Pieralisi wrote:
> The way PCI memory resources are exported to user space through procfs
> is not uniform across architectures. In particular, some architectures
> (ie SPARC) export the resource PCI bus address to user space, whereas
> others (ARM, PowerPC, Microblaze) export the resource CPU physical address.
> This convention should be followed when it comes to passing the pgoff
> values to the mmap syscall to map the resource in question.
> 
> Consequently, the checks applied to the offset passed to the mmap syscall
> (in pci_mmap_fits()) are to be interpreted differently on different
> architectures, and in particular they should match the values exported to
> user space through the pci_resource_to_user() conversion function.
> 
> This patch series addresses two issues. First patch applies the
> pci_resource_to_user() filter to the PCI resource that is being
> mapped in order to carry out a proper check against the pgoff passed
> from user space. Second patch fixes the way the pgoff is handled in
> the ARM pci_mmap_page_range() implementation.
> 
> v2 posting:
> 
> http://marc.info/?l=linux-kernel&m=141416813409829&w=2
> 
> v2 => v3
> - Reworded commit log in order to try to bisect the breakage
>   and provide insights into the commit history that led to the
>   current interface
> 
> v1 => v2
> - Reworded commit log as per RMK comments

Any further comments on this patch ? I would like to send patch 2 to
RMK patch system asap and if possible get an agreement on patch 1.

Thank you,
Lorenzo

> Lorenzo Pieralisi (2):
>   drivers: pci: fix pci_mmap_fits() implementation for procfs mmap
>   arm: kernel: fix pci_mmap_page_range() offset calculation
> 
>  arch/arm/kernel/bios32.c | 10 ++--------
>  drivers/pci/pci-sysfs.c  | 13 ++++++++-----
>  2 files changed, 10 insertions(+), 13 deletions(-)
> 
> -- 
> 2.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
