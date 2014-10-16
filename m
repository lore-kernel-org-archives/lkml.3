Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaJPKFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:05:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:53455 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaJPKFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:05:22 -0400
Message-ID: <1413453882.11213.95.camel@pasglop>
Subject: Re: of/pci: Fix the conversion of IO ranges into IO resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>
Date: Thu, 16 Oct 2014 21:04:42 +1100
In-Reply-To: <20141016090529.GG4599@e106497-lin.cambridge.arm.com>
References: <20141009200235.55E5166107E@gitolite.kernel.org>
	 <1413358507.4748.4.camel@pasglop>
	 <20141015090239.GB18070@e106497-lin.cambridge.arm.com>
	 <1413428148.20705.2.camel@concordia>
	 <20141016090529.GG4599@e106497-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-16 at 10:05 +0100, Liviu Dudau wrote:
> So you are going to continue converting IO ranges as IORESOURCE_MEM resources but with a
> different flag. Is that something that powerpc depends on or is it an artifact of too
> much code living around the kernel that has built in assumption of that being the fact?
> I'm trying to understand the world around powerpc so as to attempt to make a useful
> contribution in the future.

I'm not sure I understand what you mean and which specific resources you
are talking about.

For PCI devices, the IO BAR resources have IORESOURCE_IO ... 

The case where we might get an IORESOURCE_MEM, at least that's how my old
code used to work, was is if we try to use the device-tree to convert a
PCI IO device address before we have initialized our mappings (ie, before
we have probed our PCI host bridges).

In that case, we would get an IORESOURCE_MEM (which is functional as long
as one ioremap's and uses the proper accessors for memory resources).

Once we have the PCI host bridges probed, the IO space is assigned, and
such conversion routines will transform the addresses properly into IO
resources.

Note that it's fairly rare that we use the device-tree for PCI based
resources anyway and even rarer than we do that before the PCI host
bridges have been properly setup and thus their IO space allocated.

Note that the problems exposed by these patches can be entirely reproduced
in qemu using virtio, so you should be able to test a little bit if you
have a reasonably fast x86 box to run qemu on.

Cheers,
Ben.


