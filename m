Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727AbaLBSKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:10:15 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49328 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754549AbaLBSKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:10:10 -0500
X-Sasl-enc: HPGT0osB7iAeqM0/vHDjx71BV25hcVB1vDwYwN62uB1n 1417543809
Date: Tue, 2 Dec 2014 10:10:08 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Chen <peter.chen@freescale.com>
Subject: Re: linux-next: manual merge of the usb tree with the driver-core
 tree
Message-ID: <20141202181008.GB11700@kroah.com>
References: <20141128173246.241262c4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141128173246.241262c4@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 05:32:46PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/chipidea/core.c between commit 5bc879a6a271 ("usb:
> chipidea: drop owner assignment from platform_drivers") from the
> driver-core tree and commit 8076932ff2fc ("usb: chipidea: add system
> power management support") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/usb/chipidea/core.c
> index 947ed6e78be2,e14eafb2a05e..000000000000
> --- a/drivers/usb/chipidea/core.c
> +++ b/drivers/usb/chipidea/core.c
> @@@ -751,6 -867,8 +867,7 @@@ static struct platform_driver ci_hdrc_d
>   	.remove	= ci_hdrc_remove,
>   	.driver	= {
>   		.name	= "ci_hdrc",
> + 		.pm	= &ci_pm_ops,
>  -		.owner	= THIS_MODULE,
>   	},
>   };
>   

Looks good, thanks.

greg k-h
