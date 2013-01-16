Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab3APQR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:17:27 -0500
Received: from service87.mimecast.com ([91.220.42.44]:49321 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758735Ab3APQRV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:17:21 -0500
Date: Wed, 16 Jan 2013 16:17:16 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Message-ID: <20130116161716.GA10630@arm.com>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130115154038.GA11241@arm.com>
 <20130115211441.GA13139@avionic-0098.adnet.avionic-design.de>
 <201301161400.26587.arnd@arndb.de>
MIME-Version: 1.0
In-Reply-To: <201301161400.26587.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 16 Jan 2013 16:17:17.0053 (UTC) FILETIME=[F3C67AD0:01CDF404]
X-MC-Unique: 113011616171911601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 02:00:26PM +0000, Arnd Bergmann wrote:
> On Tuesday 15 January 2013, Thierry Reding wrote:
> > Is there actually hardware that supports this? I assumed that the MSI
> > controller would have to be tightly coupled to the PCI host bridge in
> > order to raise an interrupt when an MSI is received via PCI.
> 
> No, as long as it's guaranteed that the MSI notification won't arrive
> at the CPU before any inbound DMA data before it, the MSI controller
> can be anywhere. Typically, the MSI controller is actually closer to
> the CPU core than to the PCI bridge. On X86, I believe the MSI address
> is on normally on the the "local APIC" on each CPU.

MSIs are indistinguishable from other memory-write transactions originating
from the RC other than the address they target. Anything that can capture
that write in the address space (even a page fault) could be an MSI controller
and call interrupt handlers. And so the RC / MSI controllers don't need to
be aware of each other.

Andrew Murray

