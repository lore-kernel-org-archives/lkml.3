Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbaCNVRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:17:46 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:34935 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbaCNVRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:17:44 -0400
Message-ID: <532371F4.9050509@gmail.com>
Date: Fri, 14 Mar 2014 22:17:40 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Josh Wu <josh.wu@atmel.com>
CC: g.liakhovetski@gmx.de, m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] ov2640: add support for async device registration
References: <1394791952-12941-1-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1394791952-12941-1-git-send-email-josh.wu@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On 03/14/2014 11:12 AM, Josh Wu wrote:
> +	clk = v4l2_clk_get(&client->dev, "mclk");
> +	if (IS_ERR(clk))
> +		return -EPROBE_DEFER;

You should instead make it:

		return PTR_ERR(clk);

But you will need this patch for that to work:
http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/clk/clk.c?id=a34cd4666f3da84228a82f70c94b8d9b692034ea

With this patch there is no need to overwrite any returned error
value with EPROBE_DEFER.

> @@ -1097,23 +1106,26 @@ static int ov2640_probe(struct i2c_client *client,
>   	v4l2_ctrl_new_std(&priv->hdl,&ov2640_ctrl_ops,
>   			V4L2_CID_HFLIP, 0, 1, 1, 0);
>   	priv->subdev.ctrl_handler =&priv->hdl;
> -	if (priv->hdl.error)
> -		return priv->hdl.error;
> -
> -	priv->clk = v4l2_clk_get(&client->dev, "mclk");
> -	if (IS_ERR(priv->clk)) {
> -		ret = PTR_ERR(priv->clk);
> -		goto eclkget;

--
Regards,
Sylwester
