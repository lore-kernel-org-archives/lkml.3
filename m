Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaJOW3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 18:29:40 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35177 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751188AbaJOW3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 18:29:39 -0400
Date: Wed, 15 Oct 2014 23:29:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2] arm: kernel: fix pci_mmap_page_range() offset
 calculation
Message-ID: <20141015222932.GL27405@n2100.arm.linux.org.uk>
References: <1413374624-30066-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1413374624-30066-2-git-send-email-lorenzo.pieralisi@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413374624-30066-2-git-send-email-lorenzo.pieralisi@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 01:03:41PM +0100, Lorenzo Pieralisi wrote:
> ARM relies on the standard implementation of pci_resource_to_user()
> which actually is an identity map and exports to user space
> PCI memory resources as they are stored in PCI devices resources (ie BARs)
> which represent CPU physical addresses (fixed-up using BUS to CPU
> address conversions) not PCI bus addresses.

This paragraph seems wrong.

It first says that PCI memory resources contain the same values that the
PCI device has in its BAR.  It then goes on to say that they are CPU
physical addresses.  That is not true.

For example, DC21285 systems always have done this as: the PCI bars
contain the _bus_ addresses, which tend to be in the range 0 to
0x7fffffff.  These correspond with a CPU physical address of
0x80000000 to 0xffffffff.  The PCI bus resources for IOMEM resources
contains the CPU physical address of the mapping.

> On platforms where the mapping between CPU and BUS address is not a 1:1
> mapping this is erroneous, in that an additional shift is applied to
> an already fixed-up offset passed from userspace.

Yes, I think this is a correct patch inspite of the description. :)

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
