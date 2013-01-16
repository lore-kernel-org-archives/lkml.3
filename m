Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab3APOAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:00:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52265 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab3APOAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:00:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Date: Wed, 16 Jan 2013 14:00:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Murray <andrew.murray@arm.com>,
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
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <20130115154038.GA11241@arm.com> <20130115211441.GA13139@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130115211441.GA13139@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301161400.26587.arnd@arndb.de>
X-Provags-ID: V02:K0:valu2YmzLg+QaYTd2FlKCotVeTuAcRTFL2hyJVXpZmA
 GpWyrOPW7guwXi5YyVsMbHe4knUOyaMnwdQTDTbXDeRp0Oa31J
 s5ffIjGdsD63xFXMTmyCwwccVrdEOJT/gc2JqJ9i2QqbSujeft
 9V6tTL0kaIcglte85fJ1Ktni2u90/5BDekg+6GkuhsNZ5QvKIU
 fT75/sSnpIAdaQZ3aeh6VoB//+1Op289AhmeeGlzreiC7ykeR7
 JggOvfmxT6IUzOwQIVGnYAj3xQwayp6ZIfRjxPWXtBobhXFe0B
 5gISSWAyMdO2qqYas9xInkaCXFIOPeitOpO41OlaUIWxei9Jkj
 WuPsEN6heihipB4GiBYc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2013, Thierry Reding wrote:
> Is there actually hardware that supports this? I assumed that the MSI
> controller would have to be tightly coupled to the PCI host bridge in
> order to raise an interrupt when an MSI is received via PCI.

No, as long as it's guaranteed that the MSI notification won't arrive
at the CPU before any inbound DMA data before it, the MSI controller
can be anywhere. Typically, the MSI controller is actually closer to
the CPU core than to the PCI bridge. On X86, I believe the MSI address
is on normally on the the "local APIC" on each CPU.

	Arnd
