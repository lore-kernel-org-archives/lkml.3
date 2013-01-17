Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab3AQPmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:42:43 -0500
Received: from service87.mimecast.com ([91.220.42.44]:58287 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab3AQPmk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:42:40 -0500
Date: Thu, 17 Jan 2013 15:42:36 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
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
Message-ID: <20130117154236.GA25943@arm.com>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130115154038.GA11241@arm.com>
 <20130115211441.GA13139@avionic-0098.adnet.avionic-design.de>
 <201301161400.26587.arnd@arndb.de>
 <20130116161716.GA10630@arm.com>
 <20130116183101.GA28660@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
In-Reply-To: <20130116183101.GA28660@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 17 Jan 2013 15:42:37.0862 (UTC) FILETIME=[46E4DC60:01CDF4C9]
X-MC-Unique: 113011715423816801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 06:31:01PM +0000, Thierry Reding wrote:
> Alright, putting the functions into pci_ops doesn't sound like a very
> good idea then. Or perhaps it would make sense for hardware where the
> root complex and the MSI controller are handled by the same driver.
> Basically it could be done as a shortcut and if those are not filled
> in, the drivers could still opt to look up an MSI controller from a
> phandle specified in DT.
> 
> Even another alternative would be to keep the functions within the
> struct pci_ops and use generic ones if an external MSI controller is
> used. Just tossing around ideas.

I think an ideal solution would be for additional logic in drivers/msi.c
(e.g. in functions like msi_capability_init) to determine (based on the
passed in pci_dev) which MSI controller ops to use. I'm not sure the best
way to implement an association between an MSI controller and PCI busses
(I believe arch/sparc does something like this - perhaps there will be
inspiration there).

As you've pointed out, most RCs will have their own MSI controllers - so
it should be easy to register and associate both together.

I've submitted my previous work on MSI controller registration, but it
doesn't quite solve this problem - perhaps it can be a starting point?

Andrew Murray

