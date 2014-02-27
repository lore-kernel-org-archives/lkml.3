Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaB0QA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:00:59 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:50377 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaB0QA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:00:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] pci: OF: Fix the conversion of IO ranges into IO resources.
Date: Thu, 27 Feb 2014 17:00:55 +0100
Message-ID: <8423286.OPDZmpV5UN@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140227142103.GM1692@e106497-lin.cambridge.arm.com>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com> <7049275.SxVd47MEQ4@wuerfel> <20140227142103.GM1692@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:CbDKppDFRhrPfZufWkJHRegkBHRriq4cBfENCxef0sp
 nlsccwNdgMJNA4y9NK3pSc9s+TwGAR/At4sxzTgu4DcrB2YZ0d
 j+aMhXxBZRekiTmV9ED41am1BxdQFcsdb7ddMK7s83u1+klY0a
 jByvdupAoQnQ77E3/7ygAizLvAN8FS+jq7ZC7GqVrqm3QXUN7X
 GOw/THs+fdm59eNYM+wD/SQGJVU+8irgB38jmUo1h3GR/EOYlp
 MZvhndVKTbBjK88YeTKUyLSYpxPhhsFUxj9FDHlM3Gbttnpv+Q
 K+ckEz3J4DlJ86aGav2lrwzUoWRBH8pPUg6X4Uswbfwr6tPB2r
 XzYx39rvq7OZI/17yWgo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 February 2014 14:21:03 Liviu Dudau wrote:
> On Thu, Feb 27, 2014 at 02:08:44PM +0000, Arnd Bergmann wrote:

> > I think using pci_address_to_pio() at that point is just wrong
> > in either way. Before the host is fully registered, you can't actually
> > look up the port number -- you are only trying to assign one at this time.
> > 
> > The implementation that Will wrote for ARM would work here: find the
> > next available virtual I/O range, call pci_ioremap_io on range->pci_addr
> > and then return the virtual address. Unfortunately that code is not
> > architecture independent at this time, and we will first have to come
> > up with something that can be made to work for powerpc, microblaze,
> > mips and arm.
> 
> No, no, no... we cannot use the virtual address as the start of the resource
> as this will later be used when doing pcibios_resource_to_bus().

My mistake: I meant to say return the offset into the virtual window, i.e.
what IORESOURCE_IO space is about.

> What we need here is a portable way of converting from PCI range that uses physical
> CPU addresses to a IORESOURCE_IO type resource that uses logical IO
> addresses. Using logical IO values works, as Bjorn's code treats it as
> physical address.

Right.


	Arnd
