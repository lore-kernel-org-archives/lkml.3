Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661Ab3BZST4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:19:56 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:21788 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759592Ab3BZSTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:19:54 -0500
Date: Tue, 26 Feb 2013 19:19:52 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: hverkuil@xs4all.nl, mchehab@redhat.com, sameo@linux.intel.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/9] mfd: Add header files and Kbuild plumbing for
	SI476x MFD core
Message-ID: <20130226181952.GA25842@merkur.ravnborg.org>
References: <1361896295-26138-1-git-send-email-andrew.smirnov@gmail.com> <1361896295-26138-2-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361896295-26138-2-git-send-email-andrew.smirnov@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 08:31:27AM -0800, Andrey Smirnov wrote:
> From: Andrey Smirnov <andreysm@charmander.(none)>
> 
> This patch adds all necessary header files and Kbuild plumbing for the
> core driver for Silicon Laboratories Si476x series of AM/FM tuner
> chips.
> 
> The driver as a whole is implemented as an MFD device and this patch
> adds a core portion of it that provides all the necessary
> functionality to the two other drivers that represent radio and audio
> codec subsystems of the chip.

Some small nits.

First - this patch should be the final patch - as we otherwise fail to build
the driver due to missing files (if it gets enabled).

> 
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> ---
>  drivers/mfd/Kconfig             |   13 +
>  drivers/mfd/Makefile            |    4 +
>  include/linux/mfd/si476x-core.h |  525 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 542 insertions(+)
>  create mode 100644 include/linux/mfd/si476x-core.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 1c0abd4..3214927 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -970,6 +970,19 @@ config MFD_WL1273_CORE
>  	  driver connects the radio-wl1273 V4L2 module and the wl1273
>  	  audio codec.
>  
> +config MFD_SI476X_CORE
> +	tristate "Support for Silicon Laboratories 4761/64/68 AM/FM radio."
> +	depends on I2C
> +	select MFD_CORE
> +	default n
The above line is redundant - drop it.

> +	help
> +	  This is the core driver for the SI476x series of AM/FM
> +	  radio. This MFD driver connects the radio-si476x V4L2 module
> +	  and the si476x audio codec.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called si476x-core.
> +
>  config MFD_OMAP_USB_HOST
>  	bool "Support OMAP USBHS core and TLL driver"
>  	depends on USB_EHCI_HCD_OMAP || USB_OHCI_HCD_OMAP3
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 8b977f8..bf7627b 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -131,6 +131,10 @@ obj-$(CONFIG_MFD_JZ4740_ADC)	+= jz4740-adc.o
>  obj-$(CONFIG_MFD_TPS6586X)	+= tps6586x.o
>  obj-$(CONFIG_MFD_VX855)		+= vx855.o
>  obj-$(CONFIG_MFD_WL1273_CORE)	+= wl1273-core.o
> +
> +si476x-core-objs := si476x-cmd.o si476x-prop.o si476x-i2c.o

Please use: si476x-core-y := si476x-cmd.o si476x-prop.o si476x-i2c.o

Functionality is the same - but the above is the recommended way today.
It allows you to do stuff like:

   si476x-core-$(BLA) += foobar.o


