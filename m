Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaBKJDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:03:05 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:42792 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaBKJC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:02:59 -0500
MIME-Version: 1.0
In-Reply-To: <1392026654-5343-7-git-send-email-wsa@the-dreams.de>
References: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
	<1392026654-5343-7-git-send-email-wsa@the-dreams.de>
Date: Tue, 11 Feb 2014 17:02:58 +0800
Message-ID: <CAJxxZ0NWWfDOsK36_5oHD2-Ujdz1Wjhaqg0m9wbqACx6WfeTJQ@mail.gmail.com>
Subject: Re: [PATCH 06/17] i2c: i2c-bfin-twi: deprecate class based instantiation
From: Sonic Zhang <sonic.adi@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
        adi-buildroot-devel@lists.sourceforge.net,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Sonic Zhang <sonic.zhang@analog.com>

On Mon, Feb 10, 2014 at 6:04 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> Warn users that class based instantiation is going away soon in favour
> of more robust probing and faster bootup times.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> Cc: Sonic Zhang <sonic.zhang@analog.com>
> ---
>
> This patch is a suggestion. Looking for an ack by someone who actually uses
> the driver.
>
>  drivers/i2c/busses/i2c-bfin-twi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
> index 3b9bd9a..c75f0e9 100644
> --- a/drivers/i2c/busses/i2c-bfin-twi.c
> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
> @@ -669,7 +669,7 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
>         strlcpy(p_adap->name, pdev->name, sizeof(p_adap->name));
>         p_adap->algo = &bfin_twi_algorithm;
>         p_adap->algo_data = iface;
> -       p_adap->class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
> +       p_adap->class = I2C_CLASS_HWMON | I2C_CLASS_SPD | I2C_CLASS_DEPRECATED;
>         p_adap->dev.parent = &pdev->dev;
>         p_adap->timeout = 5 * HZ;
>         p_adap->retries = 3;
> --
> 1.8.5.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
