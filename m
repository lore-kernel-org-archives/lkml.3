Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944AbaEGOyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:54:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43840 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbaEGOyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:54:07 -0400
Date: Wed, 7 May 2014 15:53:27 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Srikanth Thokala <sthokal@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        marc.zyngier@arm.com
Subject: Re: [PATCH v3] pcie: Add Xilinx PCIe Host Bridge IP driver
Message-ID: <20140507145327.GB2563@arm.com>
References: <1397561911-11647-1-git-send-email-sthokal@xilinx.com>
 <201404301734.14478.arnd@arndb.de>
 <CA+mB=1K_AU5cLsW0J9OhVXmpvc+nYSZwpS5iyNXVTFpibfHq6g@mail.gmail.com>
 <4288313.uDFYZQS3W7@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4288313.uDFYZQS3W7@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Thanks for CC'ing me, Arnd.

On Wed, May 07, 2014 at 03:35:48PM +0100, Arnd Bergmann wrote:
> On Wednesday 07 May 2014 17:21:13 Srikanth Thokala wrote:
> > On Wed, Apr 30, 2014 at 9:04 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > Would it be possible to split the config space access out into
> > > a separate file? It would be nice to share that with the generic
> > > ECAM driver that Will Deacon has sent.
> > 
> > Yes, it should be possible.  Is it ok, if I work on top of this driver?
> 
> Do you mean as a follow-on patch? My feeling is that since we are trying
> to merge both for 3.16, it would be good to get it done right away if
> it doesn't cause too much extra work.

Do you mean something as simple as a helper for base + offset ECAM
addressing, or something more involved that handles the mapping as well? The
latter would need some alignment on sys->private_data, I think.

Srikanth: I'll CC you on the next version of my patches (I'll send them
now).

> > > As a general comment about the MSI implementation, I wonder if this is actually
> > > generic enough to be shared with other host controllers. It could be moved
> > > into a separate file like the config space access in that case.
> > 
> > I feel the MSI implementation is not generic by looking into the other
> > host controllers,
> > it is more specific to the hardware.  Correct me, if am wrong.
> 
> The other host controllers are certainly incompatible, but this one looks
> like it could be used on other controllers easily.
> 
> Splitting it out would also make it easier to use another MSI implementation
> like the one in the GIC.

Actually, MarcZ and I already have my driver working with GICv3 + MSI. The
code basically amounts to implementing {add,remove}_bus callbacks to set
the msi_chip for the pci_bus, based on what we got out of the devicetree.
I don't think we needed anything else... Marc?

Will
