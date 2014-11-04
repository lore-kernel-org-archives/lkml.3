Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaKDOPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:15:33 -0500
Received: from service87.mimecast.com ([91.220.42.44]:59742 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaKDOP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:15:27 -0500
Date: Tue, 4 Nov 2014 14:15:20 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <monstr@monstr.eu>,
        Martin Wilck <martin.wilck@ts.fujitsu.com>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH RFC v2 0/2] Fix procfs PCI resources mmap
Message-ID: <20141104141520.GA8802@e102568-lin.cambridge.arm.com>
References: <1414168089-8130-1-git-send-email-lorenzo.pieralisi@arm.com>
MIME-Version: 1.0
In-Reply-To: <1414168089-8130-1-git-send-email-lorenzo.pieralisi@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 04 Nov 2014 14:15:25.0135 (UTC) FILETIME=[C6EE15F0:01CFF839]
X-MC-Unique: 114110414152506101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 05:28:04PM +0100, Lorenzo Pieralisi wrote:
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

I appreciate it is hardly number one priority and by no means urgent,
but I would like to get some comments if possible on patch 1 since patch
2, that is a fix for ARM, relies on the approach we go for in order to
fix the pci_mmap_fits() behaviour (patch 1).

Comments welcome.

Thanks,
Lorenzo

> 
> v1 posting:
> 
> http://marc.info/?l=linux-kernel&m=141337461318554&w=2
> 
> v1 => v2
> - Reworded commit log as per RMK comments
> 
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
> 

