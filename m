Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaCMQvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:51:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19557 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaCMQvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:51:14 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-0d-5321e1fff26f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 8/8] devfreq: exynos4: Add busfreq driver for
 exynos4210/exynos4x12
Date: Thu, 13 Mar 2014 17:50:57 +0100
Message-id: <3380793.YDA220hUJP@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1394698649-20996-9-git-send-email-cw00.choi@samsung.com>
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
 <1394698649-20996-9-git-send-email-cw00.choi@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jAV2GR4rBBht/MVp09Pxmsbj+5Tmr
	xfwj51gtzr1ayWhxtukNu8XCtiUsFpd3zWGz+Nx7hNFixvl9TBZLr19ksrjduILN4s2Ps0wW
	E6avZbF4vOItu8Wrg20sDvwea+atYfRYufwLm8fiPS+ZPH4u387u0bdlFaPH8RvbmTw+b5Lz
	2Dg3NIAjissmJTUnsyy1SN8ugStjaX98Qa90xd72tewNjP9Fuxg5OSQETCSe/F/MAmGLSVy4
	t56ti5GLQ0hgEaPEgUOn2SGcFiaJ+w9eM4NUsQlYSUxsX8UIYosIaEjM/HsFzGYW+MokcXMe
	E4gtLBAtcWnybTYQm0VAVaL91VqwXl4BTYn+50vB6kUFPCV2bF8JVsMp4CbxYeN9FohljYwS
	U2++Z4doEJT4MfkeC8QCeYl9+6eyQtg6Evtbp7FNYBSYhaRsFpKyWUjKFjAyr2IUTS1ILihO
	Ss810itOzC0uzUvXS87P3cQIjqln0jsYVzVYHGIU4GBU4uGdcVQxWIg1say4MvcQowQHs5II
	r8xloBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeg63WgUIC6YklqdmpqQWpRTBZJg5OqQbGFAfj
	4wovjxVfbRfz8Iw+qNXWZtBhWF/69Rv3rh2S6yZsMSxhqdGdfThI5qwos8erKU5zchbUeMxM
	i1u9/Efvh3wz1gX/77f1e0455tKu9TBbVe6M4a6IvrnVfldrdhhUzHyXaXTbqPxytsy8j0u2
	ZbzXrFVNFDpXyuWx1mdSyi7pmy5Vy6YqsRRnJBpqMRcVJwIAo3RAeKUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday, March 13, 2014 05:17:29 PM Chanwoo Choi wrote:
> This patch add busfreq driver for Exynos4210/Exynos4x12 memory interface

This patch adds DT binding documentation not the driver itself.

Same comment for the patch summary line.

> and bus to support DVFS(Dynamic Voltage Frequency Scaling) according to PPMU
> counters. PPMU (Performance Profiling Monitorings Units) of Exynos4 SoC provides
> PPMU counters for DMC(Dynamic Memory Controller) to check memory bus utilization
> and then busfreq driver adjusts dynamically the operating frequency/voltage
> by using DEVFREQ Subsystem.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  .../devicetree/bindings/devfreq/exynos4_bus.txt    | 49 ++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
> 
> diff --git a/Documentation/devicetree/bindings/devfreq/exynos4_bus.txt b/Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
> new file mode 100644
> index 0000000..2a83fcc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
> @@ -0,0 +1,49 @@
> +
> +Exynos4210/4x12 busfreq driver
> +-----------------------------
> +
> +Exynos4210/4x12 Soc busfreq driver with devfreq for Memory bus frequency/voltage

SoC

> +scaling according to PPMU counters of memory controllers
> +
> +Required properties:
> +- compatible	: should contain Exynos4 SoC type as follwoing:

following

> +		  - "samsung,exynos4x12-busfreq" for Exynos4x12
> +		  - "samsung,exynos4210-busfreq" for Exynos4210
> +- reg		: offset and length of the ppmudmc0/1
> +		  - PPMU (Performance Profiling Monitoring Units)
> +		  : It is to profile performance event of DMC(Dynamic Memory
> +		  Controller) So, exynos4_bus.c can check memory bus utilization
> +		  by using PPMU of Exynos4 SoC.

It can be improved by changing ordering, i.e.

		  : PPMU of Exynos4 SoC is used to profile performance event of DMC (Dynamic
		  Memory Controller) so the driver can check memory bus utilization.

> +- clocks	: clock number of ppmudmc0/1
> +- clock-names	: clock name of ppmudmc0/1
> +- vdd_int-supply: regulator for interface block of Exynos4
> +
> +Optional properties:
> +- vdd_mif-supply: regulator for DMC block of Exynos4x12 if Exynos4x12 Soc

if using Exynos4x12 SoC

> +- regs-name	: register name of ppmudmc0/1
> +
> +All the required listed above must be defined under code busfreq with devfreq

required properties

> +Exmaple:

Example:

> +For Exynos4210 busfreq,

please add a newline here

> +	busfreq@106A0000 {
> +		compatible = "samsung,exynos4210-busfreq";
> +		reg = <0x106A0000 0x2000>, <0x106B0000 0x2000>;
> +		regs-name = "PPMU_DMC0", "PPMU_DMC1";
> +		clocks = <&clock CLK_PPMUDMC0>, <&clock CLK_PPMUDMC1>;
> +		clock-names = "ppmudmc0", "ppmudmc1";
> +
> +		vdd_int-supply = <&buck3_reg>;
> +	};
> +
> +For Exynos4x12 busfreq,

ditto

> +	busfreq@106A0000 {
> +		compatible = "samsung,exynos4x12-busfreq";
> +		reg = <0x106A0000 0x2000>, <0x106B0000 0x2000>;
> +		regs-name = "PPMU_DMC0", "PPMU_DMC1";
> +		clocks = <&clock CLK_PPMUDMC0>, <&clock CLK_PPMUDMC1>;
> +		clock-names = "ppmudmc0", "ppmudmc1";
> +
> +		vdd_mif-suppy = <&buck1_reg>;
> +		vdd_int-supply = <&buck3_reg>;
> +	};

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

