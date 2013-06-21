Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161401Ab3FUGAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:00:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38250 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161146Ab3FUGAm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:00:42 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Pantelis Antoniou" <panto@antoniou-consulting.com>,
        "Patil, Rachna" <rachna@ti.com>, "Balbi, Felipe" <balbi@ti.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Philip, Avinash" <avinashphilip@ti.com>,
        Benoit Cousson <benoit.cousson@linaro.org>
Subject: RE: linux-next: manual merge of the arm-soc tree with the mfd tree
Thread-Topic: linux-next: manual merge of the arm-soc tree with the mfd tree
Thread-Index: AQHObkPDO6rWPdrLIkm2IQ0cPIUAWpk/rA4g
Date: Fri, 21 Jun 2013 05:59:50 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73E9DF042@DBDE04.ent.ti.com>
References: <20130621155408.7e4a4c891ff4d74627b57a45@canb.auug.org.au>
In-Reply-To: <20130621155408.7e4a4c891ff4d74627b57a45@canb.auug.org.au>
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

> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/boot/dts/am33xx.dtsi between commit a82279dd6d3e ("arm:
> am33xx:
> add TSC/ADC mfd device support") from the mfd tree and commit
> 15e8246bd61b ("ARM: dts: AM33XX: Add ELM node") from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/boot/dts/am33xx.dtsi
> index 37ef320,0d4df90..0000000
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@@ -404,24 -494,14 +494,32 @@@
>   			ti,hwmods = "wkup_m3";
>   		};
> 
>  +		tscadc: tscadc@44e0d000 {
>  +			compatible = "ti,am3359-tscadc";
>  +			reg = <0x44e0d000 0x1000>;
>  +			interrupt-parent = <&intc>;
>  +			interrupts = <16>;
>  +			ti,hwmods = "adc_tsc";
>  +			status = "disabled";
>  +
>  +			tsc {
>  +				compatible = "ti,am3359-tsc";
>  +			};
>  +			am335x_adc: adc {
>  +				#io-channel-cells = <1>;
>  +				compatible = "ti,am3359-adc";
>  +			};
>  +
>  +		};
>  +
> + 		elm: elm@48080000 {
> + 			compatible = "ti,am3352-elm";
> + 			reg = <0x48080000 0x2000>;
> + 			interrupts = <4>;
> + 			ti,hwmods = "elm";
> + 			status = "disabled";
> + 		};
> +
[Pekon]: Thanks.. Yes this is ok based on commit "15e8246bd61b ("ARM: dts: AM33XX: Add ELM node")


>   		gpmc: gpmc@50000000 {
>   			compatible = "ti,am3352-gpmc";
>   			ti,hwmods = "gpmc";

with regards, pekon
