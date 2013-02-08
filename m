Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab3BHUQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:16:41 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:64358 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab3BHUQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:16:40 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v8 2/4] misc: Generic on-chip SRAM allocation driver
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org,
        Philipp Zabel <p.zabel@pengutronix.de>
In-Reply-To: <1359977538-5859-3-git-send-email-p.zabel@pengutronix.de>
References: <1359977538-5859-1-git-send-email-p.zabel@pengutronix.de> <1359977538-5859-3-git-send-email-p.zabel@pengutronix.de>
Date: Fri, 08 Feb 2013 20:16:34 +0000
Message-Id: <20130208201634.B94C83E2C02@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 Feb 2013 12:32:16 +0100, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> This driver requests and remaps a memory region as configured in the
> device tree. It serves memory from this region via the genalloc API.
> It optionally enables the SRAM clock.
> 
> Other drivers can retrieve the genalloc pool from a phandle pointing
> to this drivers' device node in the device tree.
> 
> The allocation granularity is hard-coded to 32 bytes for now,
> to make the SRAM driver useful for the 6502 remoteproc driver.
> There is overhead for bigger SRAMs, where only a much coarser
> allocation granularity is needed: At 32 bytes minimum allocation
> size, a 256 KiB SRAM needs a 1 KiB bitmap to track allocations.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
> ---
> Changes since v7:
>  - Removed obsolete __devinit/__devexit/__devexit_p
> ---
>  Documentation/devicetree/bindings/misc/sram.txt |   17 ++++
>  drivers/misc/Kconfig                            |    9 ++
>  drivers/misc/Makefile                           |    1 +
>  drivers/misc/sram.c                             |  121 +++++++++++++++++++++++
>  4 files changed, 148 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/misc/sram.txt
>  create mode 100644 drivers/misc/sram.c
> 
> diff --git a/Documentation/devicetree/bindings/misc/sram.txt b/Documentation/devicetree/bindings/misc/sram.txt
> new file mode 100644
> index 0000000..b64136c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/misc/sram.txt
> @@ -0,0 +1,17 @@
> +Generic on-chip SRAM
> +
> +Simple IO memory regions to be managed by the genalloc API.
> +
> +Required properties:
> +
> +- compatible : sram

I'm a little concerned that 'sram' is just too generic for a compatible
value and we may end up needing a blacklist of systems where the sram
device should not be driven with this driver. If you can think of
a more descriptive name here then I would use it.

However, I'm not worried about it enough to nak it and the rest of the
series looks fine.

Acked-by: Grant Likely <grant.likely@secretlab.ca>
