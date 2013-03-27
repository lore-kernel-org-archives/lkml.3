Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3C0Id7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:33:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39591 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab3C0Id4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:33:56 -0400
Message-ID: <1364373214.5442.1.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v9 RESEND 0/4] Add generic driver for on-chip SRAM
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>, Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
Date: Wed, 27 Mar 2013 09:33:34 +0100
In-Reply-To: <1363776767-2635-1-git-send-email-p.zabel@pengutronix.de>
References: <1363776767-2635-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 20.03.2013, 11:52 +0100 schrieb Philipp Zabel:
> Hi, last time I posted was a bit close to the merge window, so I'm
> reposting now. Greg, Arnd, could you take the first two patches?

Ping,

can I do anything to help move this along?

regards
Philipp

> These patches add support to configure on-chip SRAM via device-tree
> node or platform data and to obtain the resulting genalloc pool from
> the struct device pointer or a phandle pointing at the device tree node.
> This allows drivers to allocate SRAM with the genalloc API without
> hard-coding the genalloc pool pointer.
> 
> The on-chip SRAM on i.MX53 and i.MX6q can be registered via device tree
> and changed to use the simple generic SRAM driver:
> 
> 		ocram: ocram@00900000 {
> 			compatible = "fsl,imx-ocram", "mmio-sram";
> 			reg = <0x00900000 0x3f000>;
>  		};
> 
> A driver that needs to allocate SRAM buffers, like the video processing
> unit on i.MX53, can retrieve the genalloc pool from a phandle in the
> device tree using of_get_named_gen_pool(node, "iram", 0) from patch 1:
> 
> 		vpu@63ff4000 {
> 			/* ... */
> 			iram = <&ocram>;
>  		};
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
> 
> 


