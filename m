Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062AbaESU27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:28:59 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:44142 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaESU25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:28:57 -0400
Date: Mon, 19 May 2014 14:28:53 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alan <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nikhil P Rao <nikhil.rao@intel.com>
Subject: Re: [PATCH] pci: Allow very large resource windows
Message-ID: <20140519202853.GA1371@google.com>
References: <20140519130255.15364.49358.stgit@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519130255.15364.49358.stgit@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 02:03:14PM +0100, Alan wrote:
> From: Alan <alan@linux.intel.com>
> 
> This is needed for some of the Xeon Phi type systems.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

I applied this to my pci/resource branch for v3.16.  Nikhil
posted essentially the same patch a couple years ago, so I added
his signed-off-by and adopted his use of ARRAY_SIZE() to connect the
"order > 13" test with the aligns[] declaration.

Bjorn

> ---
>  drivers/pci/setup-bus.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index d219d44..4184112 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -921,7 +921,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
>  {
>  	struct pci_dev *dev;
>  	resource_size_t min_align, align, size, size0, size1;
> -	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
> +	resource_size_t aligns[14];	/* Alignments from 1Mb to 8Gb */
>  	int order, max_order;
>  	struct resource *b_res = find_free_bus_resource(bus, type);
>  	unsigned int mem64_mask = 0;
> @@ -960,7 +960,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
>  			/* For bridges size != alignment */
>  			align = pci_resource_alignment(dev, r);
>  			order = __ffs(align) - 20;
> -			if (order > 11) {
> +			if (order > 13) {
>  				dev_warn(&dev->dev, "disabling BAR %d: %pR "
>  					 "(bad alignment %#llx)\n", i, r,
>  					 (unsigned long long) align);
> 
