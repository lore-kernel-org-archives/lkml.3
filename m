Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaIYJgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:36:00 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:37191 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaIYJf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:35:58 -0400
Date: Thu, 25 Sep 2014 10:35:45 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Robert Richter <robert.richter@caviumnetworks.com>,
        Robert Richter <rric@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <Will.Deacon@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Sunil Goutham <sgoutham@cavium.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] arm64, defconfig: Enable PCI
Message-ID: <20140925093545.GE10390@e104818-lin.cambridge.arm.com>
References: <1411573068-12952-1-git-send-email-rric@kernel.org>
 <20140924162631.GI31556@rric.localhost>
 <20140924171047.GO15842@e104818-lin.cambridge.arm.com>
 <3120493.DIoQFCi5Am@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3120493.DIoQFCi5Am@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 07:40:18PM +0100, Arnd Bergmann wrote:
> On Wednesday 24 September 2014 18:10:48 Catalin Marinas wrote:
> > On Wed, Sep 24, 2014 at 05:26:31PM +0100, Robert Richter wrote:
> > > On 24.09.14 18:14:11, Arnd Bergmann wrote:
> > > > On Wednesday 24 September 2014 17:37:47 Robert Richter wrote:
> > > > >  config PCI
> > > > >         bool "PCI support"
> > > > > +       default y
> > > > >         help
> > > > >           This feature enables support for PCIe bus system. If you say Y
> > > > >           here, the kernel will include drivers and infrastructure code
> > > > >           to support PCIe bus devices.
> > > > >  
> > > > > +config PCI_MSI
> > > > > +       def_bool PCI
> > > > > +
> > > > >  config PCI_DOMAINS
> > > > >         def_bool PCI
> > > > 
> > > > There is already a PCI_MSI symbol in drivers/pci/Kconfig. Just select that
> > > > from the PCI symbol above rather than defining a second one.
> > > 
> > > The intention is not to have a second definition, instead this should
> > > enable the default value just for arm64. Thus I put it to
> > > arch/arm64/Kconfig. Otherwise it would be enabled per default on all
> > > archs.
> 
> I don't think other architectures actually see the PCI symbol that is
> defined in the arm64 Kconfig file, but I might be wrong.

Other archs wouldn't see the symbols in arch/arm64/Kconfig.

> > > We could have used select in config ARM64, but I tried to avoid using
> > > select due to the dependency issue and instead implement this with
> > > default-y/depends-on. Doing so it can be manually disabled too.
> 
> How about adding a new symbol like
> 
> config ARM64_PCI
> 	def_bool PCI
> 	select PCI_MSI

How is this different from just selecting PCI_MSI in config PCI in
arch/arm64/Kconfig? I don't see what another symbol brings.

> > It may be better to simply set PCI and PCI_MSI as defaults in defconfig
> > rather than "default y" and an additional config PCI_MSI entry.
> 
> Selecting PCI_MSI unconditionally seems fine to me. We won't have any
> ARM64 systems that only do classic PCI, and MSI is mandatory for PCIe.

OK then, we can go with a select.

-- 
Catalin
