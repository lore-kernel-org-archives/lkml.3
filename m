Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaJVPZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:25:15 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:55045 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbaJVPZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:25:12 -0400
MIME-Version: 1.0
In-Reply-To: <1413991587-11110-1-git-send-email-romain.perier@gmail.com>
References: <1413991587-11110-1-git-send-email-romain.perier@gmail.com>
Date: Wed, 22 Oct 2014 17:25:07 +0200
Message-ID: <CABgxDoKus_D=ooCz3TqyXP9CTJUgbZVxQSsw4ZgBx1oYaTefbw@mail.gmail.com>
Subject: Re: [PATCH v1 1/5] mfd: tps65910: Convert ti,system-power-controller
 DT property to poweroff-source
From: PERIER Romain <romain.perier@gmail.com>
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, robh+dt@kernel.org,
        "pawel.moll" <pawel.moll@arm.com>, mark.rutland@arm.com,
        "ijc+devicetree" <ijc+devicetree@hellion.org.uk>,
        galak <galak@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        swarren <swarren@wwwdotorg.org>,
        "thierry.reding" <thierry.reding@gmail.com>, gnurou <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is related to the following subject "[RFC v3 PATCH 1/5] of: Add
standard property for poweroff capability" and depends on the
corresponding patch.

2014-10-22 17:26 GMT+02:00 Romain Perier <romain.perier@gmail.com>:
> No longer use custom property to define poweroff capability, use the standard
> DT property instead.
>
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  drivers/mfd/tps65910.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> index 7612d89..b8dca8a 100644
> --- a/drivers/mfd/tps65910.c
> +++ b/drivers/mfd/tps65910.c
> @@ -423,8 +423,7 @@ static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
>
>         board_info->irq = client->irq;
>         board_info->irq_base = -1;
> -       board_info->pm_off = of_property_read_bool(np,
> -                       "ti,system-power-controller");
> +       board_info->pm_off = of_system_has_poweroff_source(np);
>
>         return board_info;
>  }
> --
> 1.9.1
>
