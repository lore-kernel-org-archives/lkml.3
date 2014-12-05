Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091AbaLEKaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:30:13 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:46876 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaLEKaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:30:11 -0500
X-IronPort-AV: E=Sophos;i="5.07,521,1413244800"; 
   d="scan'208";a="200646006"
Message-ID: <54818929.5000008@citrix.com>
Date: Fri, 5 Dec 2014 10:30:01 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>,
        Sander Eikelenboom <linux@eikelenboom.it>
CC: <bhelgaas@google.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-pci@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: [Xen-devel] [PATCH v5 9/9] xen/pciback: Implement PCI reset slot
 or bus with 'do_flr' SysFS attribute
References: <201412041206.sB4C6XVQ009497@userz7022.oracle.com>	 <5480528F.8010106@citrix.com> <1107877503.20141204141054@eikelenboom.it>	 <548064EA.8090905@citrix.com> <308719815.20141204150909@eikelenboom.it>	 <5480702F.2060004@citrix.com> <1578910783.20141204155025@eikelenboom.it> <1417707546.15750.100.camel@bling.home>
In-Reply-To: <1417707546.15750.100.camel@bling.home>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/14 15:39, Alex Williamson wrote:
> 
> I don't know what workaround you're talking about.  As devices are
> released from the user, vfio-pci attempts to reset them.  If
> pci_reset_function() returns success we mark the device clean, otherwise
> it gets marked dirty.  Each time a device is released, if there are
> dirty devices we test whether we can try a bus/slot reset to clean them.
> In the case of assigning a GPU this typically means that the GPU or
> audio function come through first, there's no reset mechanism so it gets
> marked dirty, the next device comes through and we manage to try a bus
> reset.  vfio-pci does not have any device specific resets, all
> functionality is added to the PCI-core, thank-you-very-much.  I even
> posted a generic PCI quirk patch recently that marks AMD VGA PM reset as
> bad so that pci_reset_function() won't claim that worked.  All VGA
> access quirks are done in QEMU, the kernel doesn't have any business in
> remapping config space over MMIO regions or trapping other config space
> backdoors.

Thanks for the info Alex, I hadn't got around to actually looking and
the vfio-pci code and was just going to what Sander said.

We probably do need to have a more in depth look at now PCI devices and
handled by both the toolstack and pciback but in the short term I would
like a simple solution that does not extend the ABI.

David
