Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab3BGKVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:21:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44477 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab3BGKVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:21:44 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
CC: "AnilKumar, Chimata" <anilkumar@ti.com>,
        "tony@atomide.com" <tony@atomide.com>, "hs@denx.de" <hs@denx.de>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: RE: [PATCH V2 5/6] ARM: regulator: add tps6507x device tree data
Thread-Topic: [PATCH V2 5/6] ARM: regulator: add tps6507x device tree data
Thread-Index: AQHN/fO2hWERaiLA30WiHOydyEJ0GphuPGlA
Date: Thu, 7 Feb 2013 10:21:09 +0000
Message-ID: <A4887BF146CD57468F700B415D2F4701583311@DBDE01.ent.ti.com>
References: <1359445134-13323-1-git-send-email-manishv.b@ti.com>
 <1359445134-13323-6-git-send-email-manishv.b@ti.com>
In-Reply-To: <1359445134-13323-6-git-send-email-manishv.b@ti.com>
Accept-Language: en-IN, en-US
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

Hi Mark,

On Tue, Jan 29, 2013 at 13:08:53, Vishwanathrao Badarkhe, Manish wrote:
> Add device tree data for tps6507x regulator by adding all tps6507x regulator nodes. Regulators are initialized based on compatible name provided in tps6507x DT file.
> 
> All tps6507x PMIC regulator device tree nodes are placed in a separate device tree include file (tps6507x.dtsi).
> tps6507x.dtsi file is created using datasheet http://www.ti.com/lit/ds/symlink/tps65070.pdf
> 
> Tested on da850-evm.
> 
> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> ---
> Changes since V1:
>  - Updated Copyright information.
> 
> :000000 100644 0000000... 4c326e5... A	arch/arm/boot/dts/tps6507x.dtsi
>  arch/arm/boot/dts/tps6507x.dtsi |   47 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 47 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/tps6507x.dtsi b/arch/arm/boot/dts/tps6507x.dtsi new file mode 100644 index 0000000..4c326e5
> --- /dev/null
> +++ b/arch/arm/boot/dts/tps6507x.dtsi
> @@ -0,0 +1,47 @@
> +/*
> + * Copyright (C) 2013 Texas Instruments Incorporated - 
> +http://www.ti.com/
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +/*
> + * Integrated Power Management Chip
> + * http://www.ti.com/lit/ds/symlink/tps65070.pdf
> + */
> +
> +&tps {
> +	compatible = "ti,tps6507x";
> +
> +	regulators {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		vdcdc1_reg: regulator@0 {
> +			reg = <0>;
> +			regulator-compatible = "VDCDC1";
> +		};
> +
> +		vdcdc2_reg: regulator@1 {
> +			reg = <1>;
> +			regulator-compatible = "VDCDC2";
> +		};
> +
> +		vdcdc3_reg: regulator@2 {
> +			reg = <2>;
> +			regulator-compatible = "VDCDC3";
> +		};
> +
> +		ldo1_reg: regulator@3 {
> +			reg = <3>;
> +			regulator-compatible = "LDO1";
> +		};
> +
> +		ldo2_reg: regulator@4 {
> +			reg = <4>;
> +			regulator-compatible = "LDO2";
> +		};
> +
> +	};
> +};
> --
> 1.7.4.1
> 
> 

If there are not any comments on this patch, Could you please 
accept this patch?

Regards, 
Manish
