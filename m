Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab3A2Nbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:31:48 -0500
Received: from service87.mimecast.com ([91.220.42.44]:36672 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3A2Nbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:31:45 -0500
Date: Tue, 29 Jan 2013 13:31:40 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Message-ID: <20130129133140.GA24193@arm.com>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130115154038.GA11241@arm.com>
 <20130115211441.GA13139@avionic-0098.adnet.avionic-design.de>
 <201301161400.26587.arnd@arndb.de>
 <20130116161716.GA10630@arm.com>
 <20130116183101.GA28660@avionic-0098.adnet.avionic-design.de>
 <20130117154236.GA25943@arm.com>
 <20130117160501.GC2186@avionic-0098.adnet.avionic-design.de>
 <20130117162218.GA29016@arm.com>
 <20130122192901.GE30647@obsidianresearch.com>
MIME-Version: 1.0
In-Reply-To: <20130122192901.GE30647@obsidianresearch.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Jan 2013 13:31:41.0174 (UTC) FILETIME=[F8E66960:01CDFE24]
X-MC-Unique: 113012913314309301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 07:29:01PM +0000, Jason Gunthorpe wrote:
> On Thu, Jan 17, 2013 at 04:22:18PM +0000, Andrew Murray wrote:
> 
> > > In either of those cases, does it make sense to use the MSI support
> > > outside the scope of the PCI infrastructure? That is, would devices
> > > other than PCI devices be able to generate an MSI?
> > 
> > I've come around to your way of thinking. Your approach sounds good for
> > registration of MSI ops - let the RC host driver do it (it probably has its
> > own), or use a helper for following a phandle to get ops that are not part
> > of the driver. MSIs won't be used outside of PCI devices.
> 
> Here is a bit of additional info on some MSI stuff..
> 
> This can be pretty complex. For instance on hyper transport systems
> the PCI to HT bridge has an MSI controller that maps between PCI and
> HT MSI formats, that mapping is configurable, so technically each
> brige could be considered a MSI controller. Typically the mapping
> controllers are all setup the same so there is not much problem with
> this. However *native* HT devices can (which are super rare) can use a
> different MSI format than PCI devices. From a linux perspective HT is
> just a variant of PCI.
>  
> On x86 the MSI is delivered to the CPU APIC complex which converts it
> into a vectored interrupt - part of the value of MSI is that the MSI
> data can vector the interrupt to a specific CPU, or group of CPUs or
> whatever.
> 
> Presumably SMP ARMs will evolve similar MSI based interrupt vectoring
> capabilities, and presumably on-chip, non-PCI peripherals will evolve
> options to use MSI as well (ie multi-queue ethernet). So it might be
> worth giving some thought to how things could migrate in that
> direction someday.
> 
> I have a bit hacky MSI driver for Kirkwood, this work you have to
> generalize the interface could let me actually upstream it :) The MSI
> is built using the Host2CPU doorbell registers, so it is entirely
> unrelated to the PCI-E RC driver.
> 
> However, my use of the MSI driver on kirkwood is to assign MSIs to a
> PCI-E device via non-standard registers, more like an on chip
> peripheral. This is because the Host2CPU doorbell doesn't fit 100%
> perfectly with the standard PCI MSI stuff, and the hardware has funny
> needs.. So an 'allocate a MSI interrupt' API would be snazzy too :)

Thanks for this. I believe Thierry may be working on improving the MSI
API - so perhaps we can see where that takes us.

Andrew Murray

