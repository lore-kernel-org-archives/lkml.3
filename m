Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab3HGH2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:28:35 -0400
Received: from fallback7.mail.ru ([94.100.176.135]:39488 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab3HGH2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:28:33 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?V2VpIE5p?= <wni@nvidia.com>
Cc: khali@linux-fr.org, swarren@wwwdotorg.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, MLongnecker@nvidia.com, linux@roeck-us.net,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAxLzJdIGh3bW9uOiAobG05MCkgQWRkIHBvd2VyIGNvbnRy?=
 =?UTF-8?B?b2w=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Wed, 07 Aug 2013 11:27:22 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1375860442.896960598@f427.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
In-Reply-To: <1375858358-15070-2-git-send-email-wni@nvidia.com>
References: <1375858358-15070-1-git-send-email-wni@nvidia.com>
 <1375858358-15070-2-git-send-email-wni@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r777SijW024482

> The device lm90 can be controlled by the vdd rail.
> Adding the power control support to power on/off the vdd rail.
> And make sure that power is enabled before accessing the device.
> 
> Signed-off-by: Wei Ni <wni@nvidia.com>
> ---
>  drivers/hwmon/lm90.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
[...]
> +	if (!data->lm90_reg) {
> +		data->lm90_reg = regulator_get(&client->dev, "vdd");
> +		if (IS_ERR_OR_NULL(data->lm90_reg)) {
> +			if (PTR_ERR(data->lm90_reg) == -ENODEV)
> +				dev_info(&client->dev,
> +					 "No regulator found for vdd. Assuming vdd is always powered.");
> +			else
> +				dev_warn(&client->dev,
> +					 "Error [%ld] in getting the regulator handle for vdd.\n",
> +					 PTR_ERR(data->lm90_reg));
> +			data->lm90_reg = NULL;
> +			mutex_unlock(&data->update_lock);
> +			return -ENODEV;
> +		}
> +	}
> +	if (is_enable) {
> +		ret = regulator_enable(data->lm90_reg);
> +		msleep(POWER_ON_DELAY);

Can this delay be handled directly from regulator?

[...]
---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
