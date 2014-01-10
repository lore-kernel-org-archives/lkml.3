Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbaAJXf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 18:35:29 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:6793 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaAJXf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 18:35:26 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Fri, 10 Jan 2014 15:15:15 -0800
Message-ID: <52D08183.7090203@synaptics.com>
Date: Fri, 10 Jan 2014 15:25:55 -0800
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andrew Duggan <aduggan@synaptics.com>,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] Input: synaptics-rmi4 - fix I2C functionality check
References: <1389339867-8399-1-git-send-email-dmitry.torokhov@gmail.com> <1389339867-8399-3-git-send-email-dmitry.torokhov@gmail.com>
In-Reply-To: <1389339867-8399-3-git-send-email-dmitry.torokhov@gmail.com>
X-Originating-IP: [10.3.20.103]
X-Brightmail-Tracker: AAAAAQAAAWE=
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 11:44 PM, Dmitry Torokhov wrote:
> When adapter does not support required functionality (I2C_FUNC_I2C) we were
> returning 0 to the upper layers, making them believe that device bound
> successfully.

Acked-by: Christopher Heiny <cheiny@synaptics.com>

>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>   drivers/input/rmi4/rmi_i2c.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/input/rmi4/rmi_i2c.c b/drivers/input/rmi4/rmi_i2c.c
> index cdc8527..c176218 100644
> --- a/drivers/input/rmi4/rmi_i2c.c
> +++ b/drivers/input/rmi4/rmi_i2c.c
> @@ -193,11 +193,10 @@ static int rmi_i2c_probe(struct i2c_client *client,
>   		pdata->sensor_name ? pdata->sensor_name : "-no name-",
>   		client->addr, pdata->attn_gpio);
>
> -	retval = i2c_check_functionality(client->adapter, I2C_FUNC_I2C);
> -	if (!retval) {
> -		dev_err(&client->dev, "i2c_check_functionality error %d.\n",
> -			retval);
> -		return retval;
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		dev_err(&client->dev,
> +			"adapter does not support required functionality.\n");
> +		return -ENODEV;
>   	}
>
>   	if (pdata->gpio_config) {
>


-- 

Christopher Heiny
Senior Staff Firmware Engineer
Synaptics Incorporated
