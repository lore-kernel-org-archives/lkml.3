Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaGGUmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:42:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaGGUmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:42:03 -0400
Date: Mon, 7 Jul 2014 22:42:43 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390@vger.kernel.org, "x86@kernel.org" <x86@kernel.org>,
        xen-devel@lists.xenproject.org,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/3] PCI/MSI: Add pci_enable_msi_partial()
Message-ID: <20140707204242.GA27809@dhcp-26-207.brq.redhat.com>
References: <cover.1402405331.git.agordeev@redhat.com>
 <4fef62a2e647a7c38e9f2a1ea4244b3506a85e2b.1402405331.git.agordeev@redhat.com>
 <20140702202201.GA28852@google.com>
 <20140704085741.GA12247@dhcp-26-207.brq.redhat.com>
 <CAErSpo6f6RXWv0DEtLBZX0jXoSUYJeWrSm7mubSJ_F-O7tQp6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6f6RXWv0DEtLBZX0jXoSUYJeWrSm7mubSJ_F-O7tQp6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 01:40:48PM -0600, Bjorn Helgaas wrote:
> As you can tell, I'm a little skeptical about this.  It's a fairly big
> change, it affects the arch interface, it seems to be targeted for
> only a single chipset (though it's widely used), and we already
> support a standard solution (MSI-X, reducing the number of vectors
> requested, or even operating with 1 vector).

Bjorn,

I surely understand your concerns. I am answering this "summary"
question right away.

Even though an extra parameter is introduced, functionally this update
is rather small. It is only the new pci_enable_msi_partial() function
that could exploit a custom 'nvec_mme' parameter. By contrast, existing
pci_enable_msi_range() function (and therefore all device drivers) is
unaffected - it just rounds up 'nvec' to the nearest power of two and
continues exactly as it has been. All archs besides x86 just ignore it.
And x86 change is fairly small as well - all necessary functionality is
already in.

Thus, at the moment it is only AHCI of concern. And no, AHCI can not do MSI-X..

Thanks!

> Bjorn

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
