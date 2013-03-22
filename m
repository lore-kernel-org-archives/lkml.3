Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692Ab3CVJjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 05:39:53 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53200 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932853Ab3CVJjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 05:39:51 -0400
Date: Fri, 22 Mar 2013 09:39:36 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [RFC PATCH RESEND v2] of/pci: Provide support for parsing PCI
 DT ranges property
Message-ID: <20130322093936.GA875@arm.com>
References: <1362140616-19346-1-git-send-email-Andrew.Murray@arm.com>
 <20130321170625.2a1bf226@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130321170625.2a1bf226@skate>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 04:06:25PM +0000, Thomas Petazzoni wrote:
> Dear Andrew Murray,
> 
> On Fri,  1 Mar 2013 12:23:36 +0000, Andrew Murray wrote:
> > This patch factors out common implementations patterns to reduce overall kernel
> > code and provide a means for host bridge drivers to directly obtain struct
> > resources from the DT's ranges property without relying on architecture specific
> > DT handling. This will make it easier to write archiecture independent host bridge
> > drivers and mitigate against further duplication of DT parsing code.
> > 
> > This patch can be used in the following way:
> > 
> > 	struct of_pci_range_iter iter;
> > 	for_each_of_pci_range(&iter, np) {
> > 
> > 		//directly access properties of the address range, e.g.:
> > 		//iter.pci_space, iter.pci_addr, iter.cpu_addr, iter.size or
> > 		//iter.flags
> > 
> > 		//alternatively obtain a struct resource, e.g.:
> > 		//struct resource res;
> > 		//range_iter_fill_resource(iter, np, res);
> > 	}
> > 
> > Additionally the implementation takes care of adjacent ranges and merges them
> > into a single range (as was the case with powerpc and microblaze).
> > 
> > The modifications to microblaze, mips and powerpc have not been tested.
> > 
> > v2:
> >   This follows on from suggestions made by Grant Likely
> >   (marc.info/?l=linux-kernel&m=136079602806328)
> > 
> > Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> 
> Thanks, I've tested this successfully with the Marvell PCIe driver. I'm
> about to send a new version of the Marvell PCIe patch set that includes
> this RFC proposal.
> 
> I only made two small changes compared to your version, detailed below.

Thanks for the feedback, all looks good to me. Do I need to give ack?

Andrew Murray
