Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaIXSlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:41:00 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:53403 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaIXSk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:40:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Robert Richter <robert.richter@caviumnetworks.com>,
        Robert Richter <rric@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <Will.Deacon@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Sunil Goutham <sgoutham@cavium.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] arm64, defconfig: Enable PCI
Date: Wed, 24 Sep 2014 20:40:18 +0200
Message-ID: <3120493.DIoQFCi5Am@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140924171047.GO15842@e104818-lin.cambridge.arm.com>
References: <1411573068-12952-1-git-send-email-rric@kernel.org> <20140924162631.GI31556@rric.localhost> <20140924171047.GO15842@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:LaG0AJOHT5G7TodyJbAFURKUz51wtc+X9nnziy2UN/0
 UIGr1UJRRnATjTk60bcOyK+pewHbCokF7zu+psT456gZBxYGDy
 VS/MpnkM8j2DnNmTyrAICNsygeSMI7XmkGZ1o+UBD3tTc/21/z
 syBa/MYvM2LVJcK5oqPbOP83enobStkq8UliGQXdOlAzQSxASd
 66KHgbnXED3K/X3ry7uB5I7+hXWDgMn17FEPzdirPcsdw6r25s
 AnANJwaRnyDcFylDYXYclnbNn+rBI7tNB/9z4bTg6FZqQRYWq0
 AbYEYq9TydgNrNP1ZZLKir29R5OkJUmUBOQAJg2Mk0mHyqXy8f
 B7/xC59yCvJQ7ycKYQDQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2014 18:10:48 Catalin Marinas wrote:
> On Wed, Sep 24, 2014 at 05:26:31PM +0100, Robert Richter wrote:
> > On 24.09.14 18:14:11, Arnd Bergmann wrote:
> > > On Wednesday 24 September 2014 17:37:47 Robert Richter wrote:
> > > >  config PCI
> > > >         bool "PCI support"
> > > > +       default y
> > > >         help
> > > >           This feature enables support for PCIe bus system. If you say Y
> > > >           here, the kernel will include drivers and infrastructure code
> > > >           to support PCIe bus devices.
> > > >  
> > > > +config PCI_MSI
> > > > +       def_bool PCI
> > > > +
> > > >  config PCI_DOMAINS
> > > >         def_bool PCI
> > > 
> > > There is already a PCI_MSI symbol in drivers/pci/Kconfig. Just select that
> > > from the PCI symbol above rather than defining a second one.
> > 
> > The intention is not to have a second definition, instead this should
> > enable the default value just for arm64. Thus I put it to
> > arch/arm64/Kconfig. Otherwise it would be enabled per default on all
> > archs.

I don't think other architectures actually see the PCI symbol that is
defined in the arm64 Kconfig file, but I might be wrong.

> > We could have used select in config ARM64, but I tried to avoid using
> > select due to the dependency issue and instead implement this with
> > default-y/depends-on. Doing so it can be manually disabled too.

How about adding a new symbol like

config ARM64_PCI
	def_bool PCI
	select PCI_MSI


> It may be better to simply set PCI and PCI_MSI as defaults in defconfig
> rather than "default y" and an additional config PCI_MSI entry.

Selecting PCI_MSI unconditionally seems fine to me. We won't have any
ARM64 systems that only do classic PCI, and MSI is mandatory for PCIe.

	Arnd
