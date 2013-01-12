Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab3ALVMn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 16:12:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60751 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab3ALVMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 16:12:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Date: Sat, 12 Jan 2013 21:12:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <20130111154516.GA25335@avionic-0098.adnet.avionic-design.de> <20130112123640.GA22505@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130112123640.GA22505@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301122112.25772.arnd@arndb.de>
X-Provags-ID: V02:K0:tZESMoSQKeJwxUeyUbmauhO5e5BxzUF0JeuYvxc68zl
 hlN/H7Oeh9y/GkZOFEryP+dfsebQCcdOBAriMJT1ZZGBwcH/7n
 OzHqmBXiMIYTb6YGz1EgJxsEuMjkszSQecCPsAkeCRMFUQ7WZc
 KwWKZxOmknJr+se8cMjy5i4Ugixqf1uQks/0I3Jt9CYu8t63OG
 vXO+QIn4Rrza0oZyfWt5x33X7DgZCHEpCoyDYpKBwoXll388Ab
 0KAdT09P2mmbpZ97EOFcsti4MIKvMTQnzrYNQKin4efclV4I/9
 zNOM6WzfflhdC9rBtFLrvP3Uze1rzqCv4BmRZ+CTurcXJAwpmM
 xBlYEjAE8h4IZWtDLmP0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 January 2013, Thierry Reding wrote:
> > I already hinted at that in one of the other subthreads. Having such a
> > multiplex would also allow the driver to be built as a module. I had
> > already thought about this when I was working on an earlier version of
> > these patches. Basically these would be two ops attached to the host
> > bridge, and the generic arch_setup_msi_irq() could then look that up
> > given the struct pci_dev that is passed to it and call this new per-
> > host bridge .setup_msi_irq().
> 
> struct pci_ops looks like a good place to put these. They'll be
> available from each struct pci_bus, so should be easy to call from
> arch_setup_msi_irq().
> 
> Any objections?
> 

struct pci_ops has a long history of being specifically about
config space read/write operations, so on the one hand it does
not feel like the right place to put interrupt specific operations,
but on the other hand, the name sounds appropriate and I cannot
think of any other place to put this, so it's fine with me.

The only alternative I can think of is to introduce a new
structure next to it in struct pci_bus, but that feels a bit
pointless. Maybe Bjorn has a preference one way or the other.

	Arnd
