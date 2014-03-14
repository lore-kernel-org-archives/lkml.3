Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbaCNRXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:23:10 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:46942 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbaCNRXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:23:08 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-8d-53233af96e63
Message-id: <53233AF8.9020501@samsung.com>
Date: Fri, 14 Mar 2014 18:23:04 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Robert Baldyga <r.baldyga@samsung.com>, ben-linux@fluff.org,
        kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com
Subject: Re: [PATCH] ARM: dts: exynos4210-trats: add max8997 IRQ
References: <1394792001-7837-1-git-send-email-r.baldyga@samsung.com>
In-reply-to: <1394792001-7837-1-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t/xq7o/rZSDDX5vsLCYtO4Ak8X8I+dY
	LfrfLGS1OPdqJaNF74KrbBabHl9jtbi8aw6bxYzz+5gsbl/mtVh75C67xdLrF5ksJkxfy2Lx
	4PBOdovWvUfYHfg81sxbw+jR0tzD5nG5r5fJ4++qF8weK5d/YfPYtKqTzWPzknqPvi2rGD0+
	b5IL4IzisklJzcksSy3St0vgyrj8xaBgEk/F5B9bGRsYd3N2MXJySAiYSNw5voUVwhaTuHBv
	PVsXIxeHkMBSRokzp+ayQzifGSWublvACFLFK6Al8fXgS7AOFgFViZXv77CD2GwCahKfGx6x
	gdj8QDVrmq6zgNiiAhEScyduZoPoFZT4MfkeWFwEKP50bTMLyAJmgU1MEvvmTgIq4uAQFnCQ
	mHVIE6RGSMBF4t6tv8wgNqeAq0Tb516wOcwC1hIrJ21jhLDlJTavecs8gVFwFpIVs5CUzUJS
	toCReRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSJx92cG4+JjVIUYBDkYlHt4LSsrBQqyJ
	ZcWVuYcYJTiYlUR49xsDhXhTEiurUovy44tKc1KLDzEycXBKNTB2ygq1Wr6q1V+2m/NY7WdD
	wVyZ3qJKa9abF9N2mnYE9uQIfVBNaa8PSwxPXSU0b+bEj4ETijikHVwTdgSquETVikpN2b5/
	PXtq+iEd8dPG6tpKt7iOrM++k/+D98ctmyWC/X8MNM+ff11n66F+JnPPlCUzWDI3ZopYKC56
	K7fnFb+i5JOpfEosxRmJhlrMRcWJAAHMa7CRAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On 14.03.2014 11:13, Robert Baldyga wrote:
> This patch adds device tree node for IRQ used by max8997.
>

Generally, this patch does not add just a node, but rather "IRQ line 
specification for the MAX8997 PMIC chip and necessary pinctrl group to 
configure pull-up and driver strength of the pin".

Also it would be nice to mention a reason for this change, e.g. what can 
be achieved after applying this patch.

Otherwise looks good.

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

--
Best regards,
Tomasz

> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>   arch/arm/boot/dts/exynos4210-trats.dts |   13 +++++++++++++
>   1 file changed, 13 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos4210-trats.dts b/arch/arm/boot/dts/exynos4210-trats.dts
> index 1d18428..0e1fc19 100644
> --- a/arch/arm/boot/dts/exynos4210-trats.dts
> +++ b/arch/arm/boot/dts/exynos4210-trats.dts
> @@ -148,6 +148,14 @@
>   		};
>   	};
>
> +	pinctrl@11000000 {
> +		max8997_irq: max8997-irq {
> +			samsung,pins = "gpx0-7";
> +			samsung,pin-pud = <3>;
> +			samsung,pin-drv = <0>;
> +		};
> +	};
> +
>   	i2c@13890000 {
>   		samsung,i2c-sda-delay = <100>;
>   		samsung,i2c-slave-addr = <0x10>;
> @@ -179,6 +187,11 @@
>   		max8997_pmic@66 {
>   			compatible = "maxim,max8997-pmic";
>
> +			pinctrl-0 = <&max8997_irq>;
> +			pinctrl-names = "default";
> +
> +			interrupt-parent = <&gpx0>;
> +			interrupts = <7 0>;
>   			reg = <0x66>;
>
>   			max8997,pmic-buck1-uses-gpio-dvs;
>
