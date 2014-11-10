Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaKJExA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 23:53:00 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44676 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244AbaKJEw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 23:52:58 -0500
X-Sasl-enc: T6abC5ME7eoyMilB7RhVySPyJ9Qi6uwn/4O94yDvUYYw 1415595176
Date: Mon, 10 Nov 2014 13:40:43 +0900
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the  tree
Message-ID: <20141110044043.GB17099@kroah.com>
References: <20141110152125.73e33634@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110152125.73e33634@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 03:21:25PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/leds/leds-gpio.c between commit a43f2cbbb009 ("leds: leds-gpio:
> Make use of device property API") from the  tree and commit
> 81902d5f658f ("leds: drop owner assignment from platform_drivers") from
> the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/leds/leds-gpio.c
> index b3c5d9d6a42b,ac4768f2b2b4..000000000000
> --- a/drivers/leds/leds-gpio.c
> +++ b/drivers/leds/leds-gpio.c
> @@@ -281,8 -287,7 +281,7 @@@ static struct platform_driver gpio_led_
>   	.remove		= gpio_led_remove,
>   	.driver		= {
>   		.name	= "leds-gpio",
> - 		.owner	= THIS_MODULE,
>  -		.of_match_table = of_match_ptr(of_gpio_leds_match),
>  +		.of_match_table = of_gpio_leds_match,
>   	},
>   };
>   


Looks good, thanks.

greg k-h
