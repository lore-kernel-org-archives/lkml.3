Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab3B1Pu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:50:59 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:11942
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760Ab3B1Pu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 10:50:57 -0500
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(z1039oz98dI936eI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1155h)
Message-ID: <1362066718.20662.2.camel@linux-builds1>
Subject: Re: [PATCH v9 0/4] Add generic driver for on-chip SRAM
From: Dinh Nguyen <dinguyen@altera.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Matt Porter <mporter@ti.com>, Dong Aisheng <dong.aisheng@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Richard Zhao <richard.zhao@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        <kernel@pengutronix.de>, Huang Shijie <shijie8@gmail.com>
Date: Thu, 28 Feb 2013 09:51:58 -0600
In-Reply-To: <1360770402-23091-1-git-send-email-p.zabel@pengutronix.de>
References: <1360770402-23091-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Wed, 2013-02-13 at 16:46 +0100, Philipp Zabel wrote:
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
> 

Sorry the late comment, with this patch I think you can probably remove:

linux/platform_data/imx-iram.himx-iram.h
mach-imx/iram_alloc.c


I don't see any usage of iram_init except for coda.

Dinh


> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 



