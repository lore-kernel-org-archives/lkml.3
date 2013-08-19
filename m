Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab3HSMQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 08:16:18 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:25732
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267Ab3HSMQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 08:16:16 -0400
X-IronPort-AV: E=Sophos;i="4.89,913,1367964000"; 
   d="scan'208";a="24237590"
Date: Mon, 19 Aug 2013 14:15:39 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Thierry Reding <thierry.reding@gmail.com>
cc: kernel-janitors@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] PCI: tegra: replace devm_request_and_ioremap by
 devm_ioremap_resource
In-Reply-To: <20130819121238.GB5740@ulmo>
Message-ID: <alpine.DEB.2.02.1308191414360.2313@hadrien>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr> <1376911241-27720-2-git-send-email-Julia.Lawall@lip6.fr> <20130819120249.GA5740@ulmo> <alpine.DEB.2.02.1308191405450.2313@hadrien> <20130819121238.GB5740@ulmo>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 Aug 2013, Thierry Reding wrote:

> On Mon, Aug 19, 2013 at 02:07:54PM +0200, Julia Lawall wrote:
> >
> >
> > On Mon, 19 Aug 2013, Thierry Reding wrote:
> >
> > > On Mon, Aug 19, 2013 at 01:20:35PM +0200, Julia Lawall wrote:
> > > > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > > >
> > > > Use devm_ioremap_resource instead of devm_request_and_ioremap.
> > > >
> > > > This was done using the semantic patch
> > > > scripts/coccinelle/api/devm_ioremap_resource.cocci
> > > >
> > > > Error-handling code was manually removed from the associated calls to
> > > > platform_get_resource.
> > > >
> > > > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> > > >
> > > > ---
> > > > The first block of modified code is followed by a call to
> > > > devm_request_mem_region for pcie->cs with no associated ioremap.  Should
> > > > ioremap be used in this case as well?
> > >
> > > No. The pcie->cs resource is 256 MiB so it's challenging to map it at
> > > once. Furthermore it requires a non-linear mapping so we do it on
> > > demand.
> >
> > OK, thanks for the explanation.  Is the comment, though, a little
> > misleading, since the mapping is not done here?
> >
> > /* request and remap configuration space */
>
> Yes, that's misleading. Given that it doesn't really add anything useful
> information either, perhaps I should just remove it.

OK, or maybe something like

/* request configuration space, but remap later, on demand */

To make it clear that something different is intended than the
devm_ioremap_resources that come just before..

julia
