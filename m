Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab3FKVYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 17:24:48 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:40166 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756279Ab3FKVYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 17:24:47 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz98dI936eI1432Ic8kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1155h)
Message-ID: <1370985888.7804.1.camel@linux-builds1>
Subject: Re: [PATCH] arm: dt: zynq: Add support for the zc706 platform
From: Dinh Nguyen <dinguyen@altera.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawn.guo@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date: Tue, 11 Jun 2013 16:24:48 -0500
In-Reply-To: <1370884204-2297-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1370884204-2297-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Soren,

On Mon, 2013-06-10 at 10:10 -0700, Soren Brinkmann wrote:
> Add a DT fragment for the zc706 Zynq platform. Also, adding a
> corresponding target to the Makefile and adding an appropriate
> compatibility string in the BSP.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/boot/dts/Makefile       |  3 ++-
>  arch/arm/boot/dts/zynq-zc706.dts | 31 +++++++++++++++++++++++++++++++
>  arch/arm/mach-zynq/common.c      |  1 +
>  3 files changed, 34 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/zynq-zc706.dts
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index b9f7121..2aecf7e 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -206,7 +206,8 @@ dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
>  	wm8505-ref.dtb \
>  	wm8650-mid.dtb \
>  	wm8850-w70v2.dtb
> -dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb
> +dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb \
> +	zynq-zc706.dtb
>  
>  targets += dtbs
>  targets += $(dtb-y)
> diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
> new file mode 100644
> index 0000000..a8a1d7d
> --- /dev/null
> +++ b/arch/arm/boot/dts/zynq-zc706.dts
> @@ -0,0 +1,31 @@
> +/*
> + *  Copyright (C) 2011 Xilinx
> + *  Copyright (C) 2012 National Instruments Corp.
> + *  Copyright (C) 2013 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +/dts-v1/;
> +/include/ "zynq-7000.dtsi"
> +
> +/ {
> +	model = "Zynq ZC706 Development Board";
> +	compatible = "xlnx,zynq-zc706", "xlnx,zynq-7000";
> +
> +	memory {
> +		device_type = "memory";
> +		reg = <0x0 0x40000000>;
> +	};
> +
> +	chosen {
> +		bootargs = "console=ttyPS1,115200 earlyprintk";
> +	};
> +
> +};
> diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
> index 5bfe703..221694b 100644
> --- a/arch/arm/mach-zynq/common.c
> +++ b/arch/arm/mach-zynq/common.c
> @@ -99,6 +99,7 @@ static void zynq_system_reset(char mode, const char *cmd)
>  
>  static const char * const zynq_dt_match[] = {
>  	"xlnx,zynq-zc702",
> +	"xlnx,zynq-zc706",

You really don't need to add zc706 here if it is already compatable with
zynq-7000.

Dinh
>  	"xlnx,zynq-7000",
>  	NULL
>  };



