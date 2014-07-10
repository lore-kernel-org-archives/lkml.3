Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaGJKLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:11:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbaGJKLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:11:16 -0400
Date: Thu, 10 Jul 2014 12:11:51 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/3] PCI/MSI: Add pci_enable_msi_partial()
Message-ID: <20140710101151.GA21629@dhcp-26-207.brq.redhat.com>
References: <cover.1402405331.git.agordeev@redhat.com>
 <4fef62a2e647a7c38e9f2a1ea4244b3506a85e2b.1402405331.git.agordeev@redhat.com>
 <20140702202201.GA28852@google.com>
 <20140704085741.GA12247@dhcp-26-207.brq.redhat.com>
 <CAErSpo6f6RXWv0DEtLBZX0jXoSUYJeWrSm7mubSJ_F-O7tQp6w@mail.gmail.com>
 <20140708122606.GB6270@dhcp-26-207.brq.redhat.com>
 <CAErSpo4oiabgoOjsGdWZpCMPnmopK4xRzB2f3tM0AiUFrdhFww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4oiabgoOjsGdWZpCMPnmopK4xRzB2f3tM0AiUFrdhFww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 10:06:48AM -0600, Bjorn Helgaas wrote:
> Out of curiosity, do you have a pointer to this?  It looks like it

I.e. ICH8 chapter 12.1.30 or ICH10 chapter 14.1.27

> uses one vector per port, and I'm wondering if the reason it requests
> 16 is because there's some possibility of a part with more than 8
> ports.

I doubt that is the reason. The only allowed MME values (powers of two)
are 0b000, 0b001, 0b010 and 0b100. As you can see, only one bit is used -
I would speculate it suits nicely to some hardware logic.

BTW, apart from AHCI, it seems the reason MSI is not going to disappear
(in a decade at least) is it is way cheaper to implement than MSI-X.

> > No, this is not an erratum. The value of 8 vectors is reserved and could
> > cause undefined results if used.
> 
> As I read the spec (PCI 3.0, sec 6.8.1.3), if MMC contains 0b100
> (requesting 16 vectors), the OS is allowed to allocate 1, 2, 4, 8, or
> 16 vectors.  If allocating 8 vectors and writing 0b011 to MME causes
> undefined results, I'd say that's a chipset defect.

Well, the PCI spec does not prevent devices to have their own specs on top
of it. Undefined results are meant on the device side here. On the MSI side
these results are likely perfectly within the PCI spec. I feel speaking as
a lawer here ;)

> Interrupt vector space is the issue I would worry about, but I think
> I'm going to put this on the back burner until it actually becomes a
> problem.

I plan to try get rid of arch_msi_check_device() hook. Should I repost
this series afterwards?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
