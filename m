Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab3CFEUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 23:20:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:58423 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab3CFEUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 23:20:37 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: "Porter, Matt" <mporter@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>
CC: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v8 6/9] ARM: dts: add AM33XX EDMA support
Thread-Topic: [PATCH v8 6/9] ARM: dts: add AM33XX EDMA support
Thread-Index: AQHOGeQZJAuI9w9TO0ijqY8AUcoQmpiYCxbA
Date: Wed, 6 Mar 2013 04:19:58 +0000
Message-ID: <F3DBB1B3EF102E4994C89758CFCA32412CD652@DBDE01.ent.ti.com>
References: <1362516795-6346-1-git-send-email-mporter@ti.com>
 <1362516795-6346-7-git-send-email-mporter@ti.com>
In-Reply-To: <1362516795-6346-7-git-send-email-mporter@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 06, 2013 at 02:23:12, Porter, Matt wrote:
> Adds AM33XX EDMA support to the am33xx.dtsi as documented in
> Documentation/devicetree/bindings/dma/ti-edma.txt
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  arch/arm/boot/dts/am33xx.dtsi |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 0957645..aaf44122 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -87,6 +87,26 @@
>  			reg = <0x48200000 0x1000>;
>  		};
>  
> +		edma: edma@49000000 {
> +			compatible = "ti,edma3";
> +			ti,hwmods = "tpcc", "tptc0", "tptc1", "tptc2";
> +			reg =	<0x49000000 0x10000>,
> +				<0x44e10f90 0x10>;
> +			interrupt-parent = <&intc>;

Is it really need of "interrupt-parent = <&intc>" here ?
as this property is already with root node.  
I am taking reference of 3.9-rc1

Thanks,
Anil

> +			interrupts = <12 13 14>;
> +			#dma-cells = <1>;
> +			dma-channels = <64>;
> +			ti,edma-regions = <4>;
> +			ti,edma-slots = <256>;
> +			ti,edma-queue-tc-map = <0 0
> +						1 1
> +						2 2>;
> +			ti,edma-queue-priority-map = <0 0
> +						      1 1
> +						      2 2>;
> +			ti,edma-default-queue = <0>;
> +		};
> +
>  		gpio1: gpio@44e07000 {
>  			compatible = "ti,omap4-gpio";
>  			ti,hwmods = "gpio1";
> -- 
> 1.7.9.5
> 
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 

