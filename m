Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaKFJwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 04:52:41 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:53752 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaKFJwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 04:52:36 -0500
Date: Thu, 6 Nov 2014 09:52:31 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Message-ID: <20141106095231.GA1923@red-moon>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
 <2148776.X8NPqiYA6S@wuerfel>
 <20141105233921.GJ6168@google.com>
 <2659321.LYB03rL97X@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2659321.LYB03rL97X@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 12:05:48AM +0000, Arnd Bergmann wrote:
> On Wednesday 05 November 2014 16:39:21 Bjorn Helgaas wrote:
> > On Wed, Oct 22, 2014 at 10:52:19PM +0200, Arnd Bergmann wrote:
> > > On Wednesday 22 October 2014 16:59:14 Lorenzo Pieralisi wrote:
> > > > On Wed, Oct 01, 2014 at 10:38:45AM +0100, Arnd Bergmann wrote:
> > > > 
> > > > [...]
> > > > 
> > > > > The arm32 implementations of pci_domain_nr/pci_proc_domain can probably be
> > > > > removed if we change the arm32 pcibios_init_hw function to call the new
> > > > > interfaces that set the domain number.
> > > > 
> > > > I wished, but it is a bit more complicated than I thought unfortunately,
> > > > mostly because some drivers, eg cns3xxx set the domain numbers
> > > > statically in pci_sys_data and this sets a chain of dependency that is
> > > > not easy to untangle. I think cns3xxx is the only legacy driver that "uses"
> > > > the domain number (in pci_sys_data) in a way that clashes with the
> > > > generic domain_nr implementation, I need to give it more thought.
> > > 
> > > Just had a look at that driver, shouldn't be too hard to change, see below.
> > > 
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > 
> > This patch is in my patchwork, but it lacks a topic & changelog and I'm not
> > sure of its state, so I'm going to drop it for now.  Please post it again
> > if you want me to do something with it.  I guess it only touches arch/arm,
> > so it would probably be merged via your tree anyway.
> 
> Lorenzo has posted an updated version as
> 
> "arm: cns3xxx: pci: remove artificial dependency on pci_sys_data domain",
> and a second patch that depends on it. That is the version we should be
> merging, though I'm not sure through which tree.

I am posting a v2 shortly, let's discuss the best way to merge it then.

Thanks,
Lorenzo
