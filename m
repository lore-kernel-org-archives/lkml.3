Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaDRTT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 15:19:27 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:38821 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbaDRTTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 15:19:24 -0400
Message-ID: <53517ABD.5060001@cogentembedded.com>
Date: Fri, 18 Apr 2014 23:19:25 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>
CC: Chris Healy <chealy@imsco-us.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] net: mdio-gpio: Use devm_ functions where possible
References: <1397614602-29694-1-git-send-email-linux@roeck-us.net> <1397614602-29694-2-git-send-email-linux@roeck-us.net>
In-Reply-To: <1397614602-29694-2-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 04/16/2014 06:16 AM, Guenter Roeck wrote:

> This simplifies error path and deinit/removal functions.

> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>   drivers/net/phy/mdio-gpio.c |   19 +++++--------------
>   1 file changed, 5 insertions(+), 14 deletions(-)

> diff --git a/drivers/net/phy/mdio-gpio.c b/drivers/net/phy/mdio-gpio.c
> index e701433..e853066 100644
> --- a/drivers/net/phy/mdio-gpio.c
> +++ b/drivers/net/phy/mdio-gpio.c
> @@ -110,7 +110,7 @@ static struct mii_bus *mdio_gpio_bus_init(struct device *dev,
[...]
> @@ -163,13 +159,8 @@ out:
>   static void mdio_gpio_bus_deinit(struct device *dev)
>   {
>   	struct mii_bus *bus = dev_get_drvdata(dev);
> -	struct mdio_gpio_info *bitbang = bus->priv;
>
> -	dev_set_drvdata(dev, NULL);

    You didn't even document this "drove-by" change. Ideally, it should have 
been in a separate patch.

> -	gpio_free(bitbang->mdio);
> -	gpio_free(bitbang->mdc);
>   	free_mdio_bitbang(bus);
> -	kfree(bitbang);
>   }

WBR, Sergei

