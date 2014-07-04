Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbaGDJxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:53:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbaGDJxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:53:50 -0400
Date: Fri, 4 Jul 2014 11:54:34 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 1/3] PCI/MSI: Add pci_enable_msi_partial()
Message-ID: <20140704095434.GC12247@dhcp-26-207.brq.redhat.com>
References: <cover.1402405331.git.agordeev@redhat.com>
 <4fef62a2e647a7c38e9f2a1ea4244b3506a85e2b.1402405331.git.agordeev@redhat.com>
 <20140702202201.GA28852@google.com>
 <063D6719AE5E284EB5DD2968C1650D6D1726BF4E@AcuExch.aculab.com>
 <20140704085816.GB12247@dhcp-26-207.brq.redhat.com>
 <063D6719AE5E284EB5DD2968C1650D6D1726C717@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1726C717@AcuExch.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 09:11:50AM +0000, David Laight wrote:
> > I might be missing something, but we are talking of MSI address space
> > here, aren't we? I am not getting how we could end up with a 'write'
> > to a random kernel location when a unclaimed MSI vector sent. We could
> > only expect a spurious interrupt at worst, which is handled and reported.
> > 
> > Anyway, as I described in my reply to Bjorn, this is not a concern IMO.
> 
> I'm thinking of the following - which might be MSI-X ?
> 1) Hardware requests some interrupts and tells the host the BAR (and offset)
>    where the 'vectors' should be written.
> 2) To raise an interrupt the hardware uses the 'vector' as the address
>    of a normal PCIe write cycle.
> 
> So if the hardware requests 4 interrupts, but the driver (believing it
> will only use 3) only write 3 vectors, and then the hardware uses the
> 4th vector it can write to a random location.
> 
> Debugging that would be hard!

MSI base address is kind of hardcoded for a platform. A combination of
MSI base address, PCI function number and MSI vector makes a PCI host to
raise interrupt on a CPU. I might be inaccurate in details, but the scenario
you described is impossible AFAICT.

> 	David
> 
> 
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
