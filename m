Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab3AUHgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 02:36:08 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:39301 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3AUHgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 02:36:05 -0500
Message-ID: <50FCEFDE.8000705@gmail.com>
Date: Mon, 21 Jan 2013 15:35:58 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Mark Zhang <markz@nvidia.com>, gnurou@gmail.com
Subject: Re: [PATCH 2/3] tegra: pwm-backlight: add tegra pwm-bl driver
References: <1358591420-7790-1-git-send-email-acourbot@nvidia.com> <1358591420-7790-3-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1358591420-7790-3-git-send-email-acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2013 06:30 PM, Alexandre Courbot wrote:
> Add a PWM-backlight subdriver for Tegra boards, with support for
> Ventana.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
[...]
>  
> +	backlight {
> +		compatible = "pwm-backlight-ventana";
> +		brightness-levels = <0 16 32 48 64 80 96 112 128 144 160 176 192 208 224 240 255>;
> +		default-brightness-level = <12>;
> +
> +		pwms = <&pwm 2 5000000>;

After read the codes of tegra pwm driver & pwm framework, I got to know
the meaning of this property. So I think we need to add a doc(e.g:
Documentation/devicetree/bindings/video/backlight/nvidia,tegra20-bl.txt)
to explain this, "Documentation/devicetree/bindings/pwm/pwm.txt" doesn't
explain this, because this may be different between different pwm drivers.

> +		pwm-names = "backlight";
> +
> +		power-supply = <&vdd_bl_reg>;
> +		panel-supply = <&vdd_pnl_reg>;
> +		bl-gpio = <&gpio 28 0>;
> +		bl-panel = <&gpio 10 0>;
> +	};
> +
[...]
> diff --git a/drivers/video/backlight/pwm_bl_tegra.c b/drivers/video/backlight/pwm_bl_tegra.c
> new file mode 100644
> index 0000000..8f2195b
> --- /dev/null
> +++ b/drivers/video/backlight/pwm_bl_tegra.c

So according to the filename, I think we can put all tegra boards codes
here, right? Just like what you do for Ventana, if I wanna add support
for cardhu, I can define similar functions -- let's say "init_cardhu",
"exit_cardhu", "notify_cardhu" and "notify_after_cardhu", right?

But I think if we do in this way, the file will become very long soon.
And there are a lot of redundant codes in it. So do you have any
suggestions?

Mark
> @@ -0,0 +1,159 @@
> +/*
> + * pwm-backlight subdriver for Tegra.
> + *
> + * Copyright (c) 2013 NVIDIA CORPORATION.  All rights reserved.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
[...]
> +MODULE_DESCRIPTION("Backlight Driver for Tegra boards");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:pwm-tegra-backlight");
> +
> +
> 
