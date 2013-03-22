Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab3CVMtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:49:09 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57486 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659Ab3CVMtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:49:06 -0400
MIME-Version: 1.0
In-Reply-To: <1363776767-2635-1-git-send-email-p.zabel@pengutronix.de>
References: <1363776767-2635-1-git-send-email-p.zabel@pengutronix.de>
Date: Fri, 22 Mar 2013 13:49:04 +0100
Message-ID: <CAHTX3dKS1QGtuhcw96dzABjsPWe-3yaxpLvshJKtwvZ1AMNcew@mail.gmail.com>
Subject: Re: [PATCH v9 RESEND 0/4] Add generic driver for on-chip SRAM
From: Michal Simek <monstr@monstr.eu>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>, Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

2013/3/20 Philipp Zabel <p.zabel@pengutronix.de>:
> Hi, last time I posted was a bit close to the merge window, so I'm
> reposting now. Greg, Arnd, could you take the first two patches?
>
> These patches add support to configure on-chip SRAM via device-tree
> node or platform data and to obtain the resulting genalloc pool from
> the struct device pointer or a phandle pointing at the device tree node.
> This allows drivers to allocate SRAM with the genalloc API without
> hard-coding the genalloc pool pointer.
>
> The on-chip SRAM on i.MX53 and i.MX6q can be registered via device tree
> and changed to use the simple generic SRAM driver:
>
>                 ocram: ocram@00900000 {
>                         compatible = "fsl,imx-ocram", "mmio-sram";
>                         reg = <0x00900000 0x3f000>;
>                 };
>
> A driver that needs to allocate SRAM buffers, like the video processing
> unit on i.MX53, can retrieve the genalloc pool from a phandle in the
> device tree using of_get_named_gen_pool(node, "iram", 0) from patch 1:
>
>                 vpu@63ff4000 {
>                         /* ... */
>                         iram = <&ocram>;
>                 };
>
> Changes since v8:
>  - The sram driver now matches against the "mmio-sram" compatible string.
>  - Removed a whitespace error in the device tree binding documentation.
>
> regards
> Philipp
>
> ---
>  Documentation/devicetree/bindings/media/coda.txt |   30 ++++++
>  Documentation/devicetree/bindings/misc/sram.txt  |   16 +++
>  arch/arm/boot/dts/imx53.dtsi                     |    5 +
>  arch/arm/boot/dts/imx6q.dtsi                     |    6 ++
>  drivers/media/platform/Kconfig                   |    1 -
>  drivers/media/platform/coda.c                    |   45 +++++---
>  drivers/misc/Kconfig                             |    9 ++
>  drivers/misc/Makefile                            |    1 +
>  drivers/misc/sram.c                              |  121 ++++++++++++++++++++++
>  include/linux/genalloc.h                         |   15 +++
>  include/linux/platform_data/coda.h               |   18 ++++
>  lib/genalloc.c                                   |   81 +++++++++++++++
>  12 files changed, 333 insertions(+), 15 deletions(-)

Andrew: 1/4 and 2/4 patches should probably go through your tree.
Can you please handle them?
Or Philipp should send these two patches directly to you?

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
