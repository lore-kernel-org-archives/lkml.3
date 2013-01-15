Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab3AOPkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:40:45 -0500
Received: from service87.mimecast.com ([91.220.42.44]:46204 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab3AOPko convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:40:44 -0500
Date: Tue, 15 Jan 2013 15:40:38 +0000
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
Message-ID: <20130115154038.GA11241@arm.com>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130114095706.GA23467@arm.com>
 <20130115120855.GA5637@avionic-0098.adnet.avionic-design.de>
 <201301151244.12767.arnd@arndb.de>
MIME-Version: 1.0
In-Reply-To: <201301151244.12767.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 15 Jan 2013 15:40:39.0140 (UTC) FILETIME=[AB4DD240:01CDF336]
X-MC-Unique: 113011515404205201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 12:44:12PM +0000, Arnd Bergmann wrote:
> On Tuesday 15 January 2013, Thierry Reding wrote:
> > I'm not sure I follow you're reasoning here. Is it possible to use MSIs
> > without PCI? If not then I think there's little sense in keeping the
> > implementations separate.
> 
> Conceptually, you can use MSI for any device, but the Linux interfaces
> for MSI are tied to PCI. If you use an MSI controller for a non-PCI
> device, it would probably just appear as a regular interrupt controller.
> 
> > Furthermore, if MSI controller and PCI host bridge are separate entities
> > how do you look up the MSI controller given a PCI device?
> 
> The host bridge can contain a pointer ot the MSI controller. You can
> have multiple host bridges sharing a single MSI controller or you
> can have separate ones for each host.

Yes and I hoped this relationship would be described by a device tree phandle
as is done for relating devices to their interrupt-parent (where device trees
are used). This would provide (arguably unnecessarily) greater flexibility,
e.g. if you have two PCI/MSI controller pairs, the MSIs only offer limited MSIs
and you only use one PCI fabric - you could service different parts of the
fabric by different MSI controllers (assuming you relate MSI controllers to
part of the fabric and that you'd want to). Perhaps there would be benefits for
virtualisation as well?

Andrew Murray

