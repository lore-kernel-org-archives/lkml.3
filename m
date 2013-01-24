Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3AXJTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:19:45 -0500
Received: from webbox1416.server-home.net ([77.236.96.61]:59201 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369Ab3AXJTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:19:39 -0500
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2013 04:19:39 EST
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Roland Stigge <stigge@antcom.de>
Cc: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.w
Subject: Re: [PATCH 3/6 v14] gpio: Add userland device interface to block GPIO
Date: Thu, 24 Jan 2013 10:13:40 +0100
Message-ID: <2755008.6LuYqOq3X4@ws-stein>
User-Agent: KMail/4.9.5 (Linux/3.6.11-gentoo; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358856404-8975-4-git-send-email-stigge@antcom.de>
References: <1358856404-8975-1-git-send-email-stigge@antcom.de> <1358856404-8975-4-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013 13:06:41, Roland Stigge wrote:
> This patch adds a character device interface to the block GPIO system.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> ---
>  Documentation/ABI/testing/dev-gpioblock |   34 ++++
>  drivers/gpio/gpiolib.c                  |  225 +++++++++++++++++++++++++++++++-
>  include/linux/gpio.h                    |   13 +
>  3 files changed, 271 insertions(+), 1 deletion(-)
> 
> --- /dev/null
> +++ linux-2.6/Documentation/ABI/testing/dev-gpioblock
> @@ -0,0 +1,34 @@
> +What:		/dev/<gpioblock>
> +Date:		Nov 2012
> +KernelVersion:	3.7
> +Contact:	Roland Stigge <stigge@antcom.de>
> +Description:	The /dev/<gpioblock> character device node provides userspace
> +		access to GPIO blocks, named exactly as the block, e.g.
> +		/dev/block0.
> +
> +		Reading:
> +		When reading sizeof(unsigned long) bytes from the device, the
> +		current state of the block, masked by the current mask (see
> +		below) can be obtained as a word. When the device is opened
> +		with O_NONBLOCK, read() always returns with data immediately,
> +		otherwise it blocks until data is available, see IRQ handling
> +		below.
> +
> +		Writing:
> +		By writing sizeof(unsigned long) bytes to the device, the
> +		current state of the block can be set. This operation is
> +		masked by the current mask (see below).
> +
> +		IRQ handling:
> +		When one or more IRQs in the block are IRQ capable, you can
                          ^^^^
I think this should be GPIOs

> +static long gpio_block_fop_ioctl(struct file *f, unsigned int cmd,
> +				 unsigned long arg)
> +{
> +	struct gpio_block *block = (struct gpio_block *)f->private_data;
> +	unsigned long __user *x = (unsigned long __user *)arg;
> +
> +	if (cmd == 0)
> +		return get_user(block->cur_mask, x);
> +
> +	return -EINVAL;
> +}

So there is no way from userspace to create/remove GPIO blocks? I know support in sysfs is problematic due to formatting, but an IOCTL for that would be nice.

Best regards,
Alexander

