Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbbAOHSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 02:18:14 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.142]:30627 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094AbbAOHSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 02:18:13 -0500
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-16.tower-180.messagelabs.com!1421306290!34747343!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Thu, 15 Jan 2015 08:18:10 +0100
Date: Thu, 15 Jan 2015 08:18:01 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [patch] mcb: request_mem_region() returns NULL on error
Message-ID: <20150115071800.GA26024@jtlinux>
References: <20150114210840.GG23203@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150114210840.GG23203@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 12:08:40AM +0300, Dan Carpenter wrote:
> The code here is checking for IS_ERR() when request_mem_region() only
> returns NULL on error and never an ERR_PTR.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/mcb/mcb-pci.c b/drivers/mcb/mcb-pci.c
> index 5e1bd5d..2d6524a 100644
> --- a/drivers/mcb/mcb-pci.c
> +++ b/drivers/mcb/mcb-pci.c
> @@ -56,9 +56,9 @@ static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	res = request_mem_region(priv->mapbase, CHAM_HEADER_SIZE,
>  				 KBUILD_MODNAME);
> -	if (IS_ERR(res)) {
> +	if (!res) {
>  		dev_err(&pdev->dev, "Failed to request PCI memory\n");
> -		ret = PTR_ERR(res);
> +		ret = -EBUSY;
>  		goto err_start;
>  	}
>  

Applied to mcb-next, thanks.
