Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3ISN4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:56:44 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:43738 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3ISN4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:56:42 -0400
MIME-Version: 1.0
In-Reply-To: <1379452259-3499-1-git-send-email-rklein@nvidia.com>
References: <1379452259-3499-1-git-send-email-rklein@nvidia.com>
Date: Thu, 19 Sep 2013 19:26:41 +0530
Message-ID: <CAKDJKT4D7VV1pxC1Bme5wptEW=2uyWBccVCv06tTwgrW20diVA@mail.gmail.com>
Subject: Re: [PATCH] drivers: power: Add support for bq24735 charger
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Darbha Sriharsha <dsriharsha@nvidia.com>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> +               ret = gpio_request(charger_device->pdata->status_gpio, name);
> +               if (ret) {
> +                       dev_err(&client->dev, "Failed gpio request: %d\n", ret);
> +                       goto err_free_name;
> +               }
> +       }

snip ...

> +err_free_name:
> +       if (name && name != charger_device->pdata->name)
> +               kfree(name);
> +
> +       return ret;
> +}

Like to know, Is there a need to free gpio which has been requested previously?
Alternatively, this can be get requested using "devm_" function so
that it will get
freed automatically during removal.

> +static int bq24735_charger_remove(struct i2c_client *client)
> +{
> +       struct bq24735_charger *charger_device = i2c_get_clientdata(client);
> +
> +       if (charger_device->irq)
> +               devm_free_irq(charger_device->dev, charger_device->irq,
> +                               &charger_device->charger);
> +
> +       power_supply_unregister(&charger_device->charger);
> +
> +       if (charger_device->charger.name != charger_device->pdata->name)
> +               kfree(charger_device->charger.name);
> +
> +       return 0;

Ditto, If go with free_gpio.


Regards
Manish Badarkhe
