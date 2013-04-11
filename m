Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab3DKNMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:12:23 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:58277 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751238Ab3DKNMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:12:21 -0400
Date: Thu, 11 Apr 2013 14:11:34 +0100
From: Andrew Murray <andrew.murray@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "siva.kallam@samsung.com" <siva.kallam@samsung.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suren.reddy@samsung.com" <suren.reddy@samsung.com>
Subject: Re: [PATCH v5 2/3] of/pci: Provide support for parsing PCI DT
 ranges property
Message-ID: <20130411131134.GC28981@arm.com>
References: <1365578969-30966-1-git-send-email-Andrew.Murray@arm.com>
 <1365578969-30966-3-git-send-email-Andrew.Murray@arm.com>
 <5165AEBA.7000803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5165AEBA.7000803@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 07:26:02PM +0100, Rob Herring wrote:
> On 04/10/2013 02:29 AM, Andrew Murray wrote:
> > This patch factors out common implementation patterns to reduce overall kernel
> > code and provide a means for host bridge drivers to directly obtain struct
> > resources from the DT's ranges property without relying on architecture specific
> > DT handling. This will make it easier to write archiecture independent host bridge
> > drivers and mitigate against further duplication of DT parsing code.
> >
> > This patch can be used in the following way:
> >
> >       struct of_pci_range_parser parser;
> >       struct of_pci_range range;
> >
> >       if (of_pci_range_parser(&parser, np))
> >               ; //no ranges property
> >
> >       for_each_of_pci_range(&parser, &range) {
> >
> >               /*
> >                       directly access properties of the address range, e.g.:
> >                       range.pci_space, range.pci_addr, range.cpu_addr,
> >                       range.size, range.flags
> >
> >                       alternatively obtain a struct resource, e.g.:
> >                       struct resource res;
> >                       of_pci_range_to_resource(&range, np, &res);
> >               */
> >       }
> >
> > Additionally the implementation takes care of adjacent ranges and merges them
> > into a single range (as was the case with powerpc and microblaze).
> >
> > Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> > ---
> 
> A few minor things below, otherwise:
> 
> Reviewed-by: Rob Herring <rob.herring@calxeda.com>
> 

Thanks for the feedback, I've included this in my next spin.

Andrew Murray
