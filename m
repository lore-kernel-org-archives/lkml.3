Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaKJEwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 23:52:50 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55713 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244AbaKJEws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 23:52:48 -0500
X-Sasl-enc: bSPu0vPsKLtB+jijLk6uNT6f+V4K1acZadxqEYzJg/+x 1415595166
Date: Mon, 10 Nov 2014 13:40:37 +0900
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the pm tree
Message-ID: <20141110044037.GA17099@kroah.com>
References: <20141110151856.0b644fb3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110151856.0b644fb3@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 03:18:56PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/input/keyboard/gpio_keys_polled.c between commit b26d4e2283b6
> ("input: gpio_keys_polled: Make use of device property API") from the
> pm tree and commit 1d05726c315c ("input: keyboard: drop owner
> assignment from platform_drivers") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/input/keyboard/gpio_keys_polled.c
> index c9c1c8ca7267,10f0098f3c77..000000000000
> --- a/drivers/input/keyboard/gpio_keys_polled.c
> +++ b/drivers/input/keyboard/gpio_keys_polled.c
> @@@ -297,8 -307,7 +297,7 @@@ static struct platform_driver gpio_keys
>   	.probe	= gpio_keys_polled_probe,
>   	.driver	= {
>   		.name	= DRV_NAME,
> - 		.owner	= THIS_MODULE,
>  -		.of_match_table = of_match_ptr(gpio_keys_polled_of_match),
>  +		.of_match_table = gpio_keys_polled_of_match,
>   	},
>   };
>   module_platform_driver(gpio_keys_polled_driver);


Looks good, thanks.

greg k-h
