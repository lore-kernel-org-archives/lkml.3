Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbaLIWi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 17:38:58 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:38664 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbaLIWi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 17:38:56 -0500
Date: Tue, 9 Dec 2014 15:38:46 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Simon Horman <horms@verge.net.au>,
        Phil Edworthy <phil.edworthy@renesas.com>, linux-pci@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: rcar: fix error handling of irq_of_parse_and_map
Message-ID: <20141209223846.GC6692@google.com>
References: <20141114222153.GA39494@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114222153.GA39494@dtor-ws>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 02:21:53PM -0800, Dmitry Torokhov wrote:
> Return value of irq_of_parse_and_map() is unsigned int, with 0
> indicating failure, so testing for negative result never works.
> 
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>

Applied with Phil's ack to next-pci/host-rcar for v3.19.  This branch will
be rebased to v3.19-rc1.

> ---
> 
> Not tested, found by casual code inspection.
> 
>  drivers/pci/host/pcie-rcar.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/host/pcie-rcar.c b/drivers/pci/host/pcie-rcar.c
> index 9b356c3..6ca976f 100644
> --- a/drivers/pci/host/pcie-rcar.c
> +++ b/drivers/pci/host/pcie-rcar.c
> @@ -764,7 +764,7 @@ static int rcar_pcie_get_resources(struct platform_device *pdev,
>  		goto err_map_reg;
>  
>  	i = irq_of_parse_and_map(pdev->dev.of_node, 0);
> -	if (i < 0) {
> +	if (!i) {
>  		dev_err(pcie->dev, "cannot get platform resources for msi interrupt\n");
>  		err = -ENOENT;
>  		goto err_map_reg;
> @@ -772,7 +772,7 @@ static int rcar_pcie_get_resources(struct platform_device *pdev,
>  	pcie->msi.irq1 = i;
>  
>  	i = irq_of_parse_and_map(pdev->dev.of_node, 1);
> -	if (i < 0) {
> +	if (!i) {
>  		dev_err(pcie->dev, "cannot get platform resources for msi interrupt\n");
>  		err = -ENOENT;
>  		goto err_map_reg;
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
> 
> -- 
> Dmitry
