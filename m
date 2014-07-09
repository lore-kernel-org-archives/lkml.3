Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaGII7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:59:18 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57475 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbaGII7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:59:14 -0400
Date: Wed, 9 Jul 2014 09:59:11 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 3/9] pci: Introduce pci_register_io_range() helper
 function.
Message-ID: <20140709085910.GP6501@e106497-lin.cambridge.arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <20140708001418.GB22939@google.com>
 <20140708104050.GA6501@e106497-lin.cambridge.arm.com>
 <201407081614.18304.arnd@arndb.de>
MIME-Version: 1.0
In-Reply-To: <201407081614.18304.arnd@arndb.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 09 Jul 2014 08:59:11.0803 (UTC) FILETIME=[0D32E0B0:01CF9B54]
X-MC-Unique: 114070909591205801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 03:14:17PM +0100, Arnd Bergmann wrote:
> On Tuesday 08 July 2014, Liviu Dudau wrote:
> > > Here's what these look like in /proc/iomem and /proc/ioports (note that
> > > there are two resource structs for each memory-mapped IO port space: one
> > > IORESOURCE_MEM for the memory-mapped area (used only by the host bridge
> > > driver), and one IORESOURCE_IO for the I/O port space (this becomes the
> > > parent of a region used by a regular device driver):
> > > 
> > >   /proc/iomem:
> > >     PCI Bus 0000:00 I/O Ports 00000000-00000fff
> > >     PCI Bus 0001:00 I/O Ports 01000000-01000fff
> > > 
> > >   /proc/ioports:
> > >     00000000-00000fff : PCI Bus 0000:00
> > >     01000000-01000fff : PCI Bus 0001:00
> > 
> > OK, I have a question that might be ovbious to you but I have missed the answer
> > so far: how does the IORESOURCE_MEM area gets created? Is it the host bridge
> > driver's job to do it? Is it something that the framework should do when it
> > notices that the IORESOURCE_IO is memory mapped?
> 
> The host bridge driver should either register the IORESOURCE_MEM resource
> itself from its probe or setup function, or it should get registered behind
> the covers in drivers using of_create_pci_host_bridge().
> 
> Your new pci_host_bridge_of_get_ranges already loops over all the 
> resources, so it would be a good place to put that.

OK, so it is not something that I've missed, just something that x86-64 does and
my version doesn't yet.

Thanks for confirming that.

Liviu

> 
> 	Arnd
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

