Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3AXKAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:00:42 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:50617 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab3AXKAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:00:38 -0500
X-Auth-Info: YZg+7LDAt9QMids+2ISqaC4OB2yztd2TyuWHkpkZUb8=
Message-ID: <5101144B.1090600@denx.de>
Date: Thu, 24 Jan 2013 12:00:27 +0100
From: Heiko Schocher <hs@denx.de>
Organization: DENX Software Engineering
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LDOC <linux-doc@vger.kernel.org>, devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH RFC] media: tvp514x: add OF support
References: <1359018740-6399-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1359018740-6399-1-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Prabhakar,

On 24.01.2013 10:12, Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> add OF support for the tvp514x driver.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  This patch is on top of following patches:
>  1: https://patchwork.kernel.org/patch/1930941/
>  2: http://patchwork.linuxtv.org/patch/16193/
>  3: https://patchwork.kernel.org/patch/1944901/
> 
>  .../devicetree/bindings/media/i2c/tvp514x.txt      |   30 ++++++++++
>  drivers/media/i2c/tvp514x.c                        |   60 ++++++++++++++++++--
>  2 files changed, 85 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp514x.txt b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> new file mode 100644
> index 0000000..3cce323
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> @@ -0,0 +1,30 @@

[...]
> diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
> index a4f0a70..0e2b15c 100644
> --- a/drivers/media/i2c/tvp514x.c
> +++ b/drivers/media/i2c/tvp514x.c
> @@ -12,6 +12,7 @@
>   *     Hardik Shah <hardik.shah@ti.com>
>   *     Manjunath Hadli <mrh@ti.com>
>   *     Karicheri Muralidharan <m-karicheri2@ti.com>
> + *     Prabhakar Lad <prabhakar.lad@ti.com>
>   *
>   * This package is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -930,6 +931,50 @@ static struct tvp514x_decoder tvp514x_dev = {
>  
>  };
>  
> +#if defined(CONFIG_OF)
> +static const struct of_device_id tvp514x_of_match[] = {
> +	{.compatible = "ti,tvp514x-decoder", },
> +	{},
> +}

Missing semicolon here. Without, gcc throws here an error
when compiling this driver as a module.

> +MODULE_DEVICE_TABLE(of, tvp514x_of_match);
> +
[...]

bye,
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
