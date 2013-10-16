Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935199Ab3JPSG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:06:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934615Ab3JPSG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:06:28 -0400
Date: Wed, 16 Oct 2013 11:06:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dhanunjaya <dhanunjaya.matrix@gmail.com>
Cc: eli.billauer@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: xillybus: fix for quoted string split
 across lines
Message-ID: <20131016180627.GA17116@kroah.com>
References: <1381946272-18651-1-git-send-email-dhanunjaya.matrix@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381946272-18651-1-git-send-email-dhanunjaya.matrix@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 11:27:52PM +0530, Dhanunjaya wrote:
> This is a patch to the xillybus_of.c file that fixes up a
> quoted string split across lines warning found by the
> checkpatch.pl tool.
> 
> Signed-off-by: Dhanunjaya <dhanunjaya.matrix@gmail.com>

I need a full name here please.

> ---
>  drivers/staging/xillybus/xillybus_of.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/xillybus/xillybus_of.c b/drivers/staging/xillybus/xillybus_of.c
> index 92c2931..822ef4d 100644
> --- a/drivers/staging/xillybus/xillybus_of.c
> +++ b/drivers/staging/xillybus/xillybus_of.c
> @@ -117,8 +117,7 @@ static int xilly_drv_probe(struct platform_device *op)
>  
>  	rc = of_address_to_resource(dev->of_node, 0, &endpoint->res);
>  	if (rc) {
> -		pr_warn("xillybus: Failed to obtain device tree "
> -			"resource\n");
> +		pr_warn("xillybus: Failed to obtain device tree resource\n");

This should be using dev_warn() instead.

>  		goto failed_request_regions;
>  	}
>  
> @@ -141,8 +140,7 @@ static int xilly_drv_probe(struct platform_device *op)
>  	rc = request_irq(irq, xillybus_isr, 0, xillyname, endpoint);
>  
>  	if (rc) {
> -		pr_err("xillybus: Failed to register IRQ handler. "
> -		       "Aborting.\n");
> +		pr_err("xillybus: Failed to register IRQ handler, Aborting...\n");

dev_err() instead please here as well.

thanks,

greg k-h
