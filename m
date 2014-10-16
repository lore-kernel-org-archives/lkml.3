Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaJPKYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:24:09 -0400
Received: from service87.mimecast.com ([91.220.42.44]:59057 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbaJPKYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:24:05 -0400
Date: Thu, 16 Oct 2014 11:24:45 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2] arm: kernel: fix pci_mmap_page_range() offset
 calculation
Message-ID: <20141016102445.GA28187@red-moon>
References: <1413374624-30066-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1413374624-30066-2-git-send-email-lorenzo.pieralisi@arm.com>
 <20141015222932.GL27405@n2100.arm.linux.org.uk>
MIME-Version: 1.0
In-Reply-To: <20141015222932.GL27405@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 16 Oct 2014 10:24:01.0880 (UTC) FILETIME=[4E043D80:01CFE92B]
X-MC-Unique: 114101611240202701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

thanks for having a look.

On Wed, Oct 15, 2014 at 11:29:32PM +0100, Russell King - ARM Linux wrote:
> On Wed, Oct 15, 2014 at 01:03:41PM +0100, Lorenzo Pieralisi wrote:
> > ARM relies on the standard implementation of pci_resource_to_user()
> > which actually is an identity map and exports to user space
> > PCI memory resources as they are stored in PCI devices resources (ie BARs)
> > which represent CPU physical addresses (fixed-up using BUS to CPU
> > address conversions) not PCI bus addresses.
> 
> This paragraph seems wrong.
> 
> It first says that PCI memory resources contain the same values that the
> PCI device has in its BAR.  It then goes on to say that they are CPU
> physical addresses.  That is not true.
> 
> For example, DC21285 systems always have done this as: the PCI bars
> contain the _bus_ addresses, which tend to be in the range 0 to
> 0x7fffffff.  These correspond with a CPU physical address of
> 0x80000000 to 0xffffffff.  The PCI bus resources for IOMEM resources
> contains the CPU physical address of the mapping.

It is a commit log wording problem, I exactly meant what you said, I
will reword it (or remove "ie BARs" from it, since it is misleading).

I think that the word "BAR" is a bit misused in helpers function like:

pci_resource_{start/end/len}

too but as long as we all know what that means (and I write proper
commit logs :)) it is all fine.

> > On platforms where the mapping between CPU and BUS address is not a 1:1
> > mapping this is erroneous, in that an additional shift is applied to
> > an already fixed-up offset passed from userspace.
> 
> Yes, I think this is a correct patch inspite of the description. :)

Great, I will reword it and wait for comments on patch 1 that changes
pci_mmap_fits() (it does not affect ARM, but would like to get both changes
in coherently - ie if I am asked to change patch 1 I will probably have
to change this patch too).

Thanks,
Lorenzo

