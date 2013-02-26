Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab3BZWlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:41:12 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:36500 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758032Ab3BZWlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:41:10 -0500
Date: Tue, 26 Feb 2013 14:41:06 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        horms@verge.net.au, linus.walleij@linaro.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] gpio: em: Add Device Tree support
Message-ID: <20130226224106.GC20670@core.coreip.homeip.net>
References: <20130226132623.18365.36583.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226132623.18365.36583.sendpatchset@w520>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Tue, Feb 26, 2013 at 10:26:23PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Update the Emma Mobile GPIO driver to add DT support.
> 

...

> @@ -366,15 +387,33 @@ static int em_gio_remove(struct platform
>  	return 0;
>  }
>  

#ifdef CONFIG_OF here? No need to have extra aliases in modules if OF
support is not enabled (or is entire ARM arch now enables device tree?).

> +static const struct of_device_id em_gio_dt_ids[] = {
> +	{ .compatible = "renesas,em-gio", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, em_gio_dt_ids);
> +
>  static struct platform_driver em_gio_device_driver = {
>  	.probe		= em_gio_probe,
>  	.remove		= em_gio_remove,
>  	.driver		= {
>  		.name	= "em_gio",
> +		.of_match_table = em_gio_dt_ids,
> +		.owner		= THIS_MODULE,
>  	}
>  };
>  

-- 
Dmitry
