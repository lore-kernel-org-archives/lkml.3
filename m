Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaKLK13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:27:29 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56673 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaKLK11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:27:27 -0500
Date: Wed, 12 Nov 2014 10:27:26 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <monstr@monstr.eu>,
        Martin Wilck <martin.wilck@ts.fujitsu.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH RFC v2 1/2] drivers: pci: fix pci_mmap_fits()
 implementation for procfs mmap
Message-ID: <20141112102726.GD6759@red-moon>
References: <1414168089-8130-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1414168089-8130-2-git-send-email-lorenzo.pieralisi@arm.com>
 <20141110230454.GA21470@google.com>
 <1415777029.5124.42.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415777029.5124.42.camel@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 07:23:49AM +0000, Benjamin Herrenschmidt wrote:
> On Mon, 2014-11-10 at 16:04 -0700, Bjorn Helgaas wrote:
> > But I'm not sure I have this right.  If the procfs offset is either
> > the
> > CPU physical address or the BAR value, then pci_resource_to_user()
> > should be (depending on the arch) either a no-op or use
> > pci_resource_to_bus().
> > 
> > But that's not how it's implemented.  Maybe it *could* be?  If
> > pci_resource_to_user() gives you something that's not a CPU physical
> > address and not a bus address, what *does* it give you, and why would
> > we
> > need this third kind of thing?
> > 
> > FWIW, I think the discussion leading up to pci_resource_to_user() is
> > here:
> > http://lkml.iu.edu/hypermail/linux/kernel/0504.3/0467.html
> 
> Oh, man... I remember that was all a giant trainwreck and some stuff
> just couldn't be made completely right due to broken assumptions by
> the proc code and users of it... but I don't remember all the details.
> 
> I think /proc users don't necessarily pass a BAR value but something
> they try to somewhat translates themselves via the "resources" file,
> which ends up working ... or not, depending on various factors such
> as 32 vs 64 bit etc...
> 
> I wonder who still uses this interface....

+1, even though I do not think that leaving it as it is is a good idea,
hence I posted this series.

I tried to fix it while fixing the way ARM pcibios code handles
pci_mmap_page_range() (for both procfs and sysfs mappings).

I will do what Bjorn suggested, more comments from arches maintainers
are welcome.

Lorenzo
