Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaLERXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 12:23:09 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48333 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLERXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 12:23:07 -0500
Date: Fri, 5 Dec 2014 12:22:50 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Sander Eikelenboom <linux@eikelenboom.it>, bhelgaas@google.com,
        linux-pci@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [Xen-devel] [PATCH v5 9/9] xen/pciback: Implement PCI reset slot
 or bus with 'do_flr' SysFS attribute
Message-ID: <20141205172250.GA2895@laptop.dumpdata.com>
References: <201412041206.sB4C6XVQ009497@userz7022.oracle.com>
 <5480528F.8010106@citrix.com>
 <1107877503.20141204141054@eikelenboom.it>
 <548064EA.8090905@citrix.com>
 <308719815.20141204150909@eikelenboom.it>
 <5480702F.2060004@citrix.com>
 <1578910783.20141204155025@eikelenboom.it>
 <1417707546.15750.100.camel@bling.home>
 <54818929.5000008@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54818929.5000008@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 10:30:01AM +0000, David Vrabel wrote:
> On 04/12/14 15:39, Alex Williamson wrote:
> > 
> > I don't know what workaround you're talking about.  As devices are
> > released from the user, vfio-pci attempts to reset them.  If
> > pci_reset_function() returns success we mark the device clean, otherwise
> > it gets marked dirty.  Each time a device is released, if there are
> > dirty devices we test whether we can try a bus/slot reset to clean them.
> > In the case of assigning a GPU this typically means that the GPU or
> > audio function come through first, there's no reset mechanism so it gets
> > marked dirty, the next device comes through and we manage to try a bus
> > reset.  vfio-pci does not have any device specific resets, all
> > functionality is added to the PCI-core, thank-you-very-much.  I even
> > posted a generic PCI quirk patch recently that marks AMD VGA PM reset as
> > bad so that pci_reset_function() won't claim that worked.  All VGA
> > access quirks are done in QEMU, the kernel doesn't have any business in
> > remapping config space over MMIO regions or trapping other config space
> > backdoors.
> 
> Thanks for the info Alex, I hadn't got around to actually looking and
> the vfio-pci code and was just going to what Sander said.
> 
> We probably do need to have a more in depth look at now PCI devices and
> handled by both the toolstack and pciback but in the short term I would
> like a simple solution that does not extend the ABI.

Could you enumerate the 'simple solution' then please? I am having
a frustrating time figuring out what it is that you are proposing.


> 
> David
