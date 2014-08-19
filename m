Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaHSBoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 21:44:16 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:42698 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbaHSBoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 21:44:13 -0400
Date: Tue, 19 Aug 2014 09:44:01 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Wei Yang <weiyang@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v9 02/12] PCI: OF: Parse and map the IRQ when adding the
 PCI device.
Message-ID: <20140819014401.GB9558@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
 <1407860725-25202-3-git-send-email-Liviu.Dudau@arm.com>
 <20140814145804.GA5586@richard>
 <20140814154959.GG25761@e106497-lin.cambridge.arm.com>
 <20140815085632.GA4954@richard>
 <20140815103052.GD27553@e106497-lin.cambridge.arm.com>
 <20140818142550.GN20043@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818142550.GN20043@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081901-0005-0000-0000-00000095809B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 03:25:50PM +0100, Catalin Marinas wrote:
>...
>> Well, it will become necessary as old code gets dismantled and converted towards
>> this patchset. To give you an example that I'm familiar with, for arch/arm the
>> host bridge drivers have moved into drivers/pci/host, but they still depend/use
>> the bios32 infrastructure that takes care of setting up the irq. When they switch
>> to my version they would have to go and debug the "irq not being assigned" issue
>> and it is quite likely that some of the people doing the conversion will complain
>> about my code rather than understanding the issue. What I'm trying to do is to
>> make switching to my patchset as painless as possible, with a cleanup to remove
>> redundant operations coming after the switchover.
>
>While the goal is fine, until we see a common pattern for what needs to
>go into pcibios_add_device() I think we should have an arm64-specific
>implementation (and probably an arm32 specific one as well). I can see
>powerpc uses it for setting the DMA ops. Would we have a similar need on
>arm64 to choose between coherent and non-coherent dma_ops?

Liviu,

I have the same feeling with Catalin. An arm64-specific implementation of
pcibios_add_device() would be better.

No more other concerns from my side.

>
>Also at some point we'll get ACPI support, so I'm not sure what we do
>with assigning the dev->irq here but definitely of_* functions won't
>work.
>
>-- 
>Catalin

-- 
Richard Yang
Help you, Help me

