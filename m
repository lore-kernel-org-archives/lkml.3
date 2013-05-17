Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab3EQDua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:50:30 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:33961 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754836Ab3EQDu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:50:27 -0400
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 May 2013 23:50:27 EDT
X-Sasl-enc: zljP3MW9ZmNO8UxCNgodf7dusr2Q6V0KBo9QZNkXr7NZ 1368762120
Date: Thu, 16 May 2013 17:34:59 -0700
From: Greg KH <greg@kroah.com>
To: Libo Chen <libo.chen@huawei.com>
Cc: stern@rowland.harvard.edu, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        lizefan@huawei.com, Libo Chen <chenlibo.3@gmail.com>
Subject: Re: [PATCH 3/4] usb: ohci: fix goto wrong tag in err case
Message-ID: <20130517003459.GB10235@kroah.com>
References: <1368075491-38728-1-git-send-email-libo.chen@huawei.com>
 <1368075491-38728-4-git-send-email-libo.chen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368075491-38728-4-git-send-email-libo.chen@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 12:58:10PM +0800, Libo Chen wrote:
> From: Libo Chen <chenlibo.3@gmail.com>
> 
> fix goto wrong tag in usb_hcd_nxp_probe
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/usb/host/ohci-nxp.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-nxp.c b/drivers/usb/host/ohci-nxp.c
> index f4988fb..eb294a9 100644
> --- a/drivers/usb/host/ohci-nxp.c
> +++ b/drivers/usb/host/ohci-nxp.c
> @@ -234,7 +234,7 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
>  	if (usb_disabled()) {
>  		dev_err(&pdev->dev, "USB is disabled\n");
>  		ret = -ENODEV;
> -		goto out;
> +		goto out1;

Please fix this up to use better error case names so this does not
happen again.

thanks,

greg k-h
