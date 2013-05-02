Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab3EBLWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 07:22:38 -0400
Received: from drsnuggles.stderr.nl ([94.142.244.14]:60941 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886Ab3EBLWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 07:22:36 -0400
Date: Thu, 2 May 2013 13:22:29 +0200
From: Matthijs Kooijman <matthijs@stdin.nl>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: dwc2: use devm_ioremap_resource()
Message-ID: <20130502112228.GI13691@login.drsnuggles.stderr.nl>
Mail-Followup-To: Laurent Navet <laurent.navet@gmail.com>,
	paulz@synopsys.com, gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1367493798-32354-1-git-send-email-laurent.navet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367493798-32354-1-git-send-email-laurent.navet@gmail.com>
X-PGP-Fingerprint: 7F6A 9F44 2820 18E2 18DE  24AA CF49 D0E6 8A2F AFBC
X-PGP-Key: http://www.stderr.nl/static/files/gpg_pubkey.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-Score: -2.2 (--)
X-Spam-Report: Spamchecked on "mail.drsnuggles.stderr.nl"
	pts  rule name              description
	---- ---------------------- -------------------------------------------
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.4 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Thu, May 02, 2013 at 01:23:17PM +0200, Laurent Navet wrote:
> Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.
> 
> Found with coccicheck and this semantic patch:
>  scripts/coccinelle/api/devm_request_and_ioremap.cocci.
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> ---
>  drivers/staging/dwc2/pci.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
Patch looks good, I had a bit-for-bit identical patch in my queue here
as well :-)

Reviewed-by: Matthijs Kooijman <matthijs@stdin.nl>

Gr.

Matthijs

> diff --git a/drivers/staging/dwc2/pci.c b/drivers/staging/dwc2/pci.c
> index 69c65eb..407e021 100644
> --- a/drivers/staging/dwc2/pci.c
> +++ b/drivers/staging/dwc2/pci.c
> @@ -134,9 +134,9 @@ static int dwc2_driver_probe(struct pci_dev *dev,
>  	pci_set_power_state(dev, PCI_D0);
>  
>  	hsotg->dev = &dev->dev;
> -	hsotg->regs = devm_request_and_ioremap(&dev->dev, &dev->resource[0]);
> -	if (!hsotg->regs)
> -		return -ENOMEM;
> +	hsotg->regs = devm_ioremap_resource(&dev->dev, &dev->resource[0]);
> +	if (IS_ERR(hsotg->regs))
> +		return PTR_ERR(hsotg->regs);
>  
>  	dev_dbg(&dev->dev, "mapped PA %08lx to VA %p\n",
>  		(unsigned long)pci_resource_start(dev, 0), hsotg->regs);
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
