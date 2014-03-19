Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbaCSJSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:18:10 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:48580 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883AbaCSJSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:18:06 -0400
Message-ID: <53296094.3060209@atmel.com>
Date: Wed, 19 Mar 2014 17:17:08 +0800
From: Josh Wu <josh.wu@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: <g.liakhovetski@gmx.de>, <m.chehab@samsung.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [media] ov2640: add support for async device registration
References: <1394791952-12941-1-git-send-email-josh.wu@atmel.com> <532371F4.9050509@gmail.com>
In-Reply-To: <532371F4.9050509@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Sylwester

Thanks for your review.

On 3/15/2014 5:17 AM, Sylwester Nawrocki wrote:
> Hi Josh,
>
> On 03/14/2014 11:12 AM, Josh Wu wrote:
>> +    clk = v4l2_clk_get(&client->dev, "mclk");
>> +    if (IS_ERR(clk))
>> +        return -EPROBE_DEFER;
>
> You should instead make it:
>
>         return PTR_ERR(clk);
>
> But you will need this patch for that to work:
> http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/clk/clk.c?id=a34cd4666f3da84228a82f70c94b8d9b692034ea 
>
>
> With this patch there is no need to overwrite any returned error
> value with EPROBE_DEFER.

Thanks for the information. I will use this in v2 version.

Best Regards,
Josh Wu

>
>> @@ -1097,23 +1106,26 @@ static int ov2640_probe(struct i2c_client 
>> *client,
>>       v4l2_ctrl_new_std(&priv->hdl,&ov2640_ctrl_ops,
>>               V4L2_CID_HFLIP, 0, 1, 1, 0);
>>       priv->subdev.ctrl_handler =&priv->hdl;
>> -    if (priv->hdl.error)
>> -        return priv->hdl.error;
>> -
>> -    priv->clk = v4l2_clk_get(&client->dev, "mclk");
>> -    if (IS_ERR(priv->clk)) {
>> -        ret = PTR_ERR(priv->clk);
>> -        goto eclkget;
>
> -- 
> Regards,
> Sylwester

