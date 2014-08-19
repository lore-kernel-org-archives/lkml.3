Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaHSMFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:05:55 -0400
Received: from dliviu.plus.com ([80.229.23.120]:54951 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbaHSMFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:05:54 -0400
Date: Tue, 19 Aug 2014 13:05:30 +0100
From: Liviu Dudau <liviu@dudau.co.uk>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <Will.Deacon@arm.com>,
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
Message-ID: <20140819120530.GF13147@bart.dudau.co.uk>
References: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
 <1407860725-25202-3-git-send-email-Liviu.Dudau@arm.com>
 <20140814145804.GA5586@richard>
 <20140814154959.GG25761@e106497-lin.cambridge.arm.com>
 <20140815085632.GA4954@richard>
 <20140815103052.GD27553@e106497-lin.cambridge.arm.com>
 <20140818142550.GN20043@localhost>
 <20140819014401.GB9558@richard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140819014401.GB9558@richard>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Aug 19 13:05:52 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 13,53f33d9f3122038512710
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 09:44:01AM +0800, Wei Yang wrote:
> On Mon, Aug 18, 2014 at 03:25:50PM +0100, Catalin Marinas wrote:
> >...
> >> Well, it will become necessary as old code gets dismantled and converted towards
> >> this patchset. To give you an example that I'm familiar with, for arch/arm the
> >> host bridge drivers have moved into drivers/pci/host, but they still depend/use
> >> the bios32 infrastructure that takes care of setting up the irq. When they switch
> >> to my version they would have to go and debug the "irq not being assigned" issue
> >> and it is quite likely that some of the people doing the conversion will complain
> >> about my code rather than understanding the issue. What I'm trying to do is to
> >> make switching to my patchset as painless as possible, with a cleanup to remove
> >> redundant operations coming after the switchover.
> >
> >While the goal is fine, until we see a common pattern for what needs to
> >go into pcibios_add_device() I think we should have an arm64-specific
> >implementation (and probably an arm32 specific one as well). I can see
> >powerpc uses it for setting the DMA ops. Would we have a similar need on
> >arm64 to choose between coherent and non-coherent dma_ops?
> 
> Liviu,
> 
> I have the same feeling with Catalin. An arm64-specific implementation of
> pcibios_add_device() would be better.
> 
> No more other concerns from my side.

OK, I will make the change when returning from my holiday at the beginning of September,
when I plan to send v10.

Best regards,
Liviu

> 
> >
> >Also at some point we'll get ACPI support, so I'm not sure what we do
> >with assigning the dev->irq here but definitely of_* functions won't
> >work.
> >
> >-- 
> >Catalin
> 
> -- 
> Richard Yang
> Help you, Help me
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
-------------------
   .oooO
   (   )
    \ (  Oooo.
     \_) (   )
          ) /
         (_/

 One small step
   for me ...

