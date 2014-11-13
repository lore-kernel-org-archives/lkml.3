Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbaKMLdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:33:32 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:57456 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbaKMLcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:32:43 -0500
Date: Thu, 13 Nov 2014 11:32:34 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <monstr@monstr.eu>,
        Martin Wilck <martin.wilck@ts.fujitsu.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH RFC v2 1/2] drivers: pci: fix pci_mmap_fits()
 implementation for procfs mmap
Message-ID: <20141113113233.GA8973@red-moon>
References: <1414168089-8130-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1414168089-8130-2-git-send-email-lorenzo.pieralisi@arm.com>
 <20141110230454.GA21470@google.com>
 <20141111114825.GA4135@red-moon>
 <CAErSpo4nWpN0xDb3h7FCpExM-Q5fmr5oyuOLf6Y_w55HEQZP4w@mail.gmail.com>
 <20141111155744.GB4419@red-moon>
 <CAErSpo4bZn20LZjrayx=B51eHnNyrHHWFQMB3J_+EQF8ntg0Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4bZn20LZjrayx=B51eHnNyrHHWFQMB3J_+EQF8ntg0Kw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 05:19:31PM +0000, Bjorn Helgaas wrote:

[...]

> > I read your comment as an agreement on the approach I took in my patch,
> > except for the current pci_resource_to_user() implementation(s), which I did
> > not touch.
> 
> Yes.  I have two things I'd like to clear up:
> 
>   1) Your patch changes behavior on platforms that implement their own
> pci_resource_to_user().  So I'd like to mention the details of that in
> the changelog, e.g., "procfs mmap on arches X, Y, Z has been broken
> since commit C, and this change fixes them."  ARM doesn't implement
> pci_resource_to_user(), so I don't think ARM is one of those arches.
> But I'd really like to include specifics on what those arches are, and
> what we think is currently broken, so their maintainers at least get a
> heads-up and can look for that  breakage.

I posted a v3, where I *tried* to bisect the commits that actually broke
the procfs interface and I added a commit log to explain why, it is very
hard to bisect a specific commit (given the dependency on the arch code)
and I do not have HW to test the fix on apart from ARM machines so there
is not much I can do on that side.

Please let me know what you think, thanks for having a look.

Lorenzo
