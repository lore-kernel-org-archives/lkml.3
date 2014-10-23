Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062AbaJWEiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 00:38:07 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:37977 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaJWEiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 00:38:05 -0400
MIME-Version: 1.0
In-Reply-To: <1414037002-25528-7-git-send-email-linux@roeck-us.net>
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net> <1414037002-25528-7-git-send-email-linux@roeck-us.net>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 22 Oct 2014 21:37:23 -0700
Message-ID: <CAGVrzcYjPJWai9bxkh+WRrEEAzBKBd-LQm7zDeeouxngr_v9SQ@mail.gmail.com>
Subject: Re: [PATCH 06/14] net: dsa: Add support for hardware monitoring
To: Guenter Roeck <linux@roeck-us.net>
Cc: netdev <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-22 21:03 GMT-07:00 Guenter Roeck <linux@roeck-us.net>:
> Some Marvell switches provide chip temperature data.
> Add support for reporting it to the dsa infrastructure.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
[snip]

> +/* hwmon support ************************************************************/
> +
> +#if defined(CONFIG_HWMON) || (defined(MODULE) && defined(CONFIG_HWMON_MODULE))

IS_ENABLED(CONFIG_HWMON)?

> +
> +static ssize_t temp1_input_show(struct device *dev,
> +                               struct device_attribute *attr, char *buf)
> +{
> +       struct dsa_switch *ds = dev_get_drvdata(dev);
> +       int temp, ret;
> +
> +       ret = ds->drv->get_temp(ds, &temp);
> +       if (ret < 0)
> +               return ret;
> +
> +       return sprintf(buf, "%d\n", temp * 1000);
> +}
> +static DEVICE_ATTR_RO(temp1_input);

You probably want the number of temperature sensors to come from the
switch driver, and support arbitrary number of temperature sensors?
--
Florian
