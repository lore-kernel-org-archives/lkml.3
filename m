Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbaGIJN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:13:29 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40970 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaGIJN0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:13:26 -0400
Date: Wed, 9 Jul 2014 10:13:20 +0100
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
Message-ID: <20140709091320.GQ6501@e106497-lin.cambridge.arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <20140708212951.GA4555@google.com>
 <20140708224529.GB4980@e106497-lin.cambridge.arm.com>
 <201407090832.37918.arnd@arndb.de>
MIME-Version: 1.0
In-Reply-To: <201407090832.37918.arnd@arndb.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 09 Jul 2014 09:13:21.0620 (UTC) FILETIME=[07BAA940:01CF9B56]
X-MC-Unique: 114070910132410701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 07:32:37AM +0100, Arnd Bergmann wrote:
> On Wednesday 09 July 2014, Liviu Dudau wrote:
> > > Maybe that assumption is guaranteed by OF, but it doesn't hold for ACPI;
> > > ACPI can describe several I/O port apertures for a single bridge, each
> > > associated with a different CPU physical memory region.
> > 
> > That is actually a good catch, I've completely missed the fact that
> > io_range->pci_addr could be non-zero.
> 
> Hmm, that's what I thought in my initial review, but you convinced me
> that it's actually correct later on, and I still believe it is. Maybe
> now you got confused by your own code?

Man, it has been too long. Yes, I am now confused by my own code, which
is not a good sign.

> 
> Please have another look, I think your code in pci_host_bridge_of_get_ranges
> sufficiently handles the registration to the PCI code with the correct
> io_offset. The only thing that we might want to add is to record the
> PCI address along with the bridge->io_base: For the host driver to
> set up the mapping window correctly, you either need both of them, or
> you assume they are already set up.

Hmm, having another look at pci_host_bridge_of_get_range() I'm not convinced
that we need another storage for pci_addr. The resource gets added to the
list of resources used by the bridge offsetted by range.pci_addr, so when
re-creating the PCI bus address the value should come in play.

I will double check but I think the code is correct as it is. Sorry for the
early confusion.

Best regards,
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

