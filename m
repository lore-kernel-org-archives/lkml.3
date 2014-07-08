Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbaGIGZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:25:54 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:64619 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaGIGZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:25:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH v8 3/9] pci: Introduce pci_register_io_range() helper function.
Date: Tue, 8 Jul 2014 16:14:17 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci" <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com> <20140708001418.GB22939@google.com> <20140708104050.GA6501@e106497-lin.cambridge.arm.com>
In-Reply-To: <20140708104050.GA6501@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201407081614.18304.arnd@arndb.de>
X-Provags-ID: V02:K0:BSYs+OMBEJA0kb2MRiIisS5vJI1ANGrkXDavRd3Pzz8
 6mCCQuR5JzVHieuDlGqxWUmqbxyWfHrMmPgZLbyckipTzJTcGE
 ENf1oZ+djPRR/Qdq8BPRYGwxm/ytk42ZyTltep7Bg6xu7p+EIP
 evfSxp5cmHhhQ7rZQAQjbN0s/x+CtJ+HNiy5tVlP6Nq7Qt5CAw
 P0yZuQOmGcLVmzR52ndVB8DsRr966XMjEjtunCrbCEjp84FrCV
 SG+wc4CqvOxYhJVMURJLRCtKtr3IEHuBjYVxAx3F4NooYYY5Kb
 6n7NHH3A+WWsQBZPf5WG4jBm9cyepObcy53FUcTRCROQs37hCM
 u4gz5uM5Bnw/5Gz6Z4OJBZfq9knBdzjRdc/NBHi0+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2014, Liviu Dudau wrote:
> > Here's what these look like in /proc/iomem and /proc/ioports (note that
> > there are two resource structs for each memory-mapped IO port space: one
> > IORESOURCE_MEM for the memory-mapped area (used only by the host bridge
> > driver), and one IORESOURCE_IO for the I/O port space (this becomes the
> > parent of a region used by a regular device driver):
> > 
> >   /proc/iomem:
> >     PCI Bus 0000:00 I/O Ports 00000000-00000fff
> >     PCI Bus 0001:00 I/O Ports 01000000-01000fff
> > 
> >   /proc/ioports:
> >     00000000-00000fff : PCI Bus 0000:00
> >     01000000-01000fff : PCI Bus 0001:00
> 
> OK, I have a question that might be ovbious to you but I have missed the answer
> so far: how does the IORESOURCE_MEM area gets created? Is it the host bridge
> driver's job to do it? Is it something that the framework should do when it
> notices that the IORESOURCE_IO is memory mapped?

The host bridge driver should either register the IORESOURCE_MEM resource
itself from its probe or setup function, or it should get registered behind
the covers in drivers using of_create_pci_host_bridge().

Your new pci_host_bridge_of_get_ranges already loops over all the 
resources, so it would be a good place to put that.

	Arnd
