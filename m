Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaFDXsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:48:52 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:46773 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753810AbaFDXsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:48:50 -0400
Date: Thu, 5 Jun 2014 00:46:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Vidya Sagar <vidyas@nvidia.com>, bhelgaas@google.com,
        wangyijing@huawei.com, thierry.reding@gmail.com, jason@lakedaemon.net,
        will.deacon@arm.com, swarren@nvidia.com, kthota@nvidia.com,
        sagar.tv@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: fix debug prints relevant to PCI devices
Message-ID: <20140604234657.GD23430@n2100.arm.linux.org.uk>
References: <1401909447-8434-1-git-send-email-vidyas@nvidia.com> <538F738A.6020003@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538F738A.6020003@wwwdotorg.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 01:29:14PM -0600, Stephen Warren wrote:
> On 06/04/2014 01:17 PM, Vidya Sagar wrote:
> > As per PCIe spec, fast back-to-back transactions feature
> > is not applicable to PCIe devices. Hence, do not print
> > that fast back-to-back trasactions are disabled when
> > there is a PCIe device found on the bus
> 
> > @@ -298,6 +299,8 @@ void pcibios_fixup_bus(struct pci_bus *bus)
> >  	list_for_each_entry(dev, &bus->devices, bus_list) {
> >  		u16 status;
> >  
> > +		if (!has_pcie_dev)
> > +			has_pcie_dev = pci_pcie_cap(dev);
> 
> This sets the flag if any PCIe device is detected, even if regular PCI
> devices are also detected. I assume the two can be mixed on a bus if
> there's a bridge (although perhaps that would be separate buses, and
> child buses don't get traversed by this function?)

This function gets caller per PCI bus - if there's a bridge between
(which there should be between PCIe and PCI) then they are by definition
separate buses.  (I'm guessing that there aren't transparent bridges
between PCI and PCIe.)

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
