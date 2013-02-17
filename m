Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab3BQTDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 14:03:10 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:47365 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3BQTDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 14:03:07 -0500
Date: Sun, 17 Feb 2013 21:03:03 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ADP1653 board code for Nokia RX-51
Message-ID: <20130217190303.GC2317@blackmetal.musicnaut.iki.fi>
References: <201302171616.50152@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201302171616.50152@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Feb 17, 2013 at 04:16:49PM +0100, Pali Rohár wrote:
> I'm sending ADP1653 flash torch board code for Nokia RX-51. Kernel
> driver ADP1653 is already in upstream kernel. Board code was extracted
> from this big camera meego patch:
> 
> https://api.pub.meego.com/public/source/CE:Adaptation:N900/kernel-adaptation-n900/linux-2.6-Camera-for-Meego-N900-Adaptation-kernel-2.6.37-patch.patch

You need to sign-off the patch.

> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-rx51-camera.c

I'm not sure if adding a new file is sensible. There are already 3 board
files for RX-51, which I think is overkill.

> @@ -0,0 +1,177 @@
> +/*
> + * arch/arm/mach-omap2/board-rx51-camera.c
> + *
> + * Copyright (C) 2008 Nokia Corporation
> + *
> + * Contact: Sakari Ailus <sakari.ailus@nokia.com>
> + *          Tuukka Toivonen <tuukka.o.toivonen@nokia.com>

You should put these people to CC... Just to see if the addresses are
still valid (which I doubt).

> +static int __init rx51_adp1653_init(void)
> +{
> +	int err;
> +
> +	err = gpio_request(ADP1653_GPIO_ENABLE, "adp1653 enable");
> +	if (err) {
> +		printk(KERN_ERR ADP1653_NAME
> +		       " Failed to request EN gpio\n");
> +		err = -ENODEV;
> +		goto err_omap_request_gpio;
> +	}
> +
> +	err = gpio_request(ADP1653_GPIO_INT, "adp1653 interrupt");
> +	if (err) {
> +		printk(KERN_ERR ADP1653_NAME " Failed to request IRQ gpio\n");
> +		err = -ENODEV;
> +		goto err_omap_request_gpio_2;
> +	}
> +
> +	err = gpio_request(ADP1653_GPIO_STROBE, "adp1653 strobe");
> +	if (err) {
> +		printk(KERN_ERR ADP1653_NAME
> +		       " Failed to request STROBE gpio\n");
> +		err = -ENODEV;
> +		goto err_omap_request_gpio_3;
> +	}
> +
> +	gpio_direction_output(ADP1653_GPIO_ENABLE, 0);
> +	gpio_direction_input(ADP1653_GPIO_INT);
> +	gpio_direction_output(ADP1653_GPIO_STROBE, 0);

gpio_request_array() should be used.

> +void __init rx51_camera_init(void)
> +{
> +	if (rx51_camera_hw_init()) {
> +		printk(KERN_WARNING "%s: Unable to initialize camera\n",
> +		       __func__);
> +		return;
> +	}
> +
> +	if (omap3_init_camera(&rx51_isp_platform_data) < 0)
> +		printk(KERN_WARNING "%s: Unable to register camera platform "
> +		       "device\n", __func__);

pr_warn() should be used.

A.
