Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbaGOK0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:26:24 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39747 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082AbaGOK0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:26:20 -0400
Message-ID: <53C50181.3060302@gmail.com>
Date: Tue, 15 Jul 2014 15:55:05 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Jeong <gshark.jeong@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>
CC: Daniel Jeong <daniel.jeong@ti.com>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [RFC v5 1/2] backlight: add new tps611xx backlight driver
References: <1405418958-7596-1-git-send-email-gshark.jeong@gmail.com> <1405418958-7596-2-git-send-email-gshark.jeong@gmail.com>
In-Reply-To: <1405418958-7596-2-git-send-email-gshark.jeong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 03:39 PM, Daniel Jeong wrote:
(...)

> +
> +static int tps611xx_backlight_remove(struct platform_device *pdev)
> +{
> +	struct tps611xx_bl_data *pchip = platform_get_drvdata(pdev);
> +	const struct tps611xx_esdata *esdata = pchip->esdata;
> +
> +	device_remove_file(&(pchip->bled->dev), &dev_attr_enable);
> +	gpio_direction_output(pchip->en_gpio, 0);
> +	mdelay(esdata->time.reset);
> +	return 0;
> +}
> +

Better to move the of_device_ids also here... We can see of_match_table directly...

> +static const struct platform_device_id tps611xx_id_table[] = {
> +	{TPS61158_NAME, (unsigned long)&tps611xx_info[TPS61158_ID]},
> +	{TPS61161_NAME, (unsigned long)&tps611xx_info[TPS61161_ID]},
> +	{TPS61163_NAME, (unsigned long)&tps611xx_info[TPS61163_ID]},
> +	{TPS61165_NAME, (unsigned long)&tps611xx_info[TPS61165_ID]},
> +	{}
> +};
> +
> +static struct platform_driver tps611xx_backlight_driver = {
> +	.driver = {
> +		.name = TPS611XX_NAME,
> +		.owner = THIS_MODULE,

No need to update .owner

see:http://lxr.free-electrons.com/source/include/linux/platform_device.h#L190

-- 
Regards,
Varka Bhadram.

