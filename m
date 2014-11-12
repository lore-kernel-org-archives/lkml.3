Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaKLHmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:42:17 -0500
Received: from gate.crashing.org ([63.228.1.57]:55156 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbaKLHmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:42:16 -0500
Message-ID: <1415777029.5124.42.camel@kernel.crashing.org>
Subject: Re: [PATCH RFC v2 1/2] drivers: pci: fix pci_mmap_fits()
 implementation for procfs mmap
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <monstr@monstr.eu>,
        Martin Wilck <martin.wilck@ts.fujitsu.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Date: Wed, 12 Nov 2014 18:23:49 +1100
In-Reply-To: <20141110230454.GA21470@google.com>
References: <1414168089-8130-1-git-send-email-lorenzo.pieralisi@arm.com>
	 <1414168089-8130-2-git-send-email-lorenzo.pieralisi@arm.com>
	 <20141110230454.GA21470@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-10 at 16:04 -0700, Bjorn Helgaas wrote:
> But I'm not sure I have this right.  If the procfs offset is either
> the
> CPU physical address or the BAR value, then pci_resource_to_user()
> should be (depending on the arch) either a no-op or use
> pci_resource_to_bus().
> 
> But that's not how it's implemented.  Maybe it *could* be?  If
> pci_resource_to_user() gives you something that's not a CPU physical
> address and not a bus address, what *does* it give you, and why would
> we
> need this third kind of thing?
> 
> FWIW, I think the discussion leading up to pci_resource_to_user() is
> here:
> http://lkml.iu.edu/hypermail/linux/kernel/0504.3/0467.html

Oh, man... I remember that was all a giant trainwreck and some stuff
just couldn't be made completely right due to broken assumptions by
the proc code and users of it... but I don't remember all the details.

I think /proc users don't necessarily pass a BAR value but something
they try to somewhat translates themselves via the "resources" file,
which ends up working ... or not, depending on various factors such
as 32 vs 64 bit etc...

I wonder who still uses this interface....

Cheers,
Ben.


