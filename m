Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab3C0NAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:00:05 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:41834 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3C0NAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:00:02 -0400
MIME-Version: 1.0
In-Reply-To: <1363876214-25933-1-git-send-email-ldewangan@nvidia.com>
References: <1363876214-25933-1-git-send-email-ldewangan@nvidia.com>
Date: Wed, 27 Mar 2013 14:00:01 +0100
Message-ID: <CACRpkdY_9pEkNfp7L82nGjsjFOi-VXwPHo7_3XwjCz8XcN8osg@mail.gmail.com>
Subject: Re: [PATCH] gpio: palmas: add dt support
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        swarren@nvidia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 3:30 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

>  #ifdef CONFIG_OF_GPIO
> -       palmas_gpio->gpio_chip.of_node = palmas->dev->of_node;
> +       palmas_gpio->gpio_chip.of_node = pdev->dev.of_node;
>  #endif

OK I think that #ifdef is necessary...

> +#ifdef CONFIG_OF
> +static struct of_device_id of_palmas_gpio_match[] = {
> +       { .compatible = "ti,palmas-gpio"},
> +       { },
> +};
> +MODULE_DEVICE_TABLE(of, of_palmas_gpio_match);
> +#endif

But please drop the #ifdef here unless it causes compile errors
(I don't think it will.)

Yours,
Linus Walleij
