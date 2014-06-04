Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaFDVEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:04:31 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:37692 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaFDVE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:04:29 -0400
Date: Wed, 4 Jun 2014 15:04:05 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Vidya Sagar <vidyas@nvidia.com>, linux@arm.linux.org.uk,
        bhelgaas@google.com, wangyijing@huawei.com, thierry.reding@gmail.com,
        jason@lakedaemon.net, will.deacon@arm.com, swarren@nvidia.com,
        kthota@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, sagar.tv@gmail.com
Subject: Re: [PATCH] ARM: fix debug prints relevant to PCI devices
Message-ID: <20140604210405.GA31230@obsidianresearch.com>
References: <1401909447-8434-1-git-send-email-vidyas@nvidia.com>
 <538F738A.6020003@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538F738A.6020003@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
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

I like the concept, and the logic looks OK as is (though pci_is_pcie
is a better choice). The function is called on a bus number basis, and
it isn't physically possible to mix technology on a single bus number.

Jason
