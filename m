Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbbAVQr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:47:58 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22324 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbbAVQr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:47:56 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-e6-54c129279201
Message-id: <54C129B0.1090404@samsung.com>
Date: Thu, 22 Jan 2015 17:47:44 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: tomasz.figa@gmail.com, mturquette@linaro.org, kgene@kernel.org,
        pankaj.dubey@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, sw0312.kim@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/12] clk: samsung: exynos5433: Add clocks using common
 clock framework
References: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
 <1421821618-8627-2-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1421821618-8627-2-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t/xq7rqmgdDDFZtt7S4vF/b4vqX56wW
	k+5PYLHof/ya2eLyrjlsFjPO72OyeDrhIpvFoq1f2C1mTH7JZrFq1x9GBy6PnbPusntsWtXJ
	5nHn2h42j74tqxg9Pm+SC2CN4rJJSc3JLEst0rdL4MqY8/k2Y8E95YpN814yNzB2y3YxcnJI
	CJhINNyczwZhi0lcuLceyObiEBJYyiixfNFnFgjnE6PE7GnHmEGqeAW0JJ5efAlmswioSjT1
	bAKz2QQMJXqP9jGC2KICERIn7+5hh6gXlPgx+R4LiC0ioCEx8+8VsBpmgTeMEi86vboYOTiE
	BRIldq/jAgkLCdRLLN/cBjaSU8BV4vLvH4wgJcwCehL3L2pBdMpLbF7zlnkCo8AsJAtmIVTN
	QlK1gJF5FaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZI8H/dwbj0mNUhRgEORiUe3ogNB0KE
	WBPLiitzDzFKcDArifC+VDkYIsSbklhZlVqUH19UmpNafIiRiYNTqoFRZOvJm1xfF3xxX6jT
	/EJ26lXDI+kfm0Oy8lXM90ZpcpizXdPrkcvZL6p8ku3O/CnZWjlOSwPzZkgXK7DOd6rfUPrv
	xP7nlwQ3Tq6I71sT06x8Qq3zsZK39krX3olCJ69d6V215/y5JEu3TSIH+oN67Bc9OHfOeHHa
	RcFb2dlbRX5e+ddlupBPiaU4I9FQi7moOBEAy1M9IVwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 21/01/15 07:26, Chanwoo Choi wrote:
> This patch adds the support for CMU (Clock Management Units) of Exynos5433
> which is 64bit SoC and has Octa-cores. This patch supports necessary clocks
> (PLL/MMC/UART/MCT/I2C/SPI) for kernel boot and includes binding documentation
> for Exynos5433 clock controller.

> diff --git a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
> new file mode 100644
> index 0000000..72cd0ba
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
> @@ -0,0 +1,106 @@
> +* Samsung Exynos5433 CMU (Clock Management Units)
> +
> +The Exynos5433 clock controller generates and supplies clock to various
> +controllers within the Exynos5433 SoC.
> +
> +Required Properties:
> +
> +- compatible: should be one of the following.
> +  - "samsung,exynos5433-cmu-top"   - clock controller compatible for CMU_TOP
> +    which generates clocks for IMEM/FSYS/G3D/GSCL/HEVC/MSCL/G2D/MFC/PERIC/PERIS
> +    domains and bus clocks.
> +  - "samsung,exynos5433-cmu-cpif"  - clock controller compatible for CMU_CPIF
> +    which generates clocks for LLI (Low Latency Interface) IP.
> +  - "samsung,exynos5433-cmu-mif"   - clock controller compatible for CMU_MIF
> +    which generates clocks for DRAM Memory Controller domain.
> +  - "samsung,exynos5433-cmu-peric" - clock controller compatible for CMU_PERIC
> +    which generates clocks for UART/I2C/SPI/I2S/PCM/SPDIF/PWM/SLIMBUS IPs.
> +  - "samsung,exynos5433-cmu-peris" - clock controller compatible for CMU_PERIS
> +    which generates clocks for PMU/TMU/MCT/WDT/RTC/SECKEY/TZPC IPs.
> +  - "samsung,exynos5433-cmu-fsys"  - clock controller compatible for CMU_FSYS
> +    which generates clocks for USB/UFS/SDMMC/TSI/PDMA IPs.
> +
> +- reg: physical base address of the controller and length of memory mapped
> +  region.
> +
> +- #clock-cells: should be 1.
> +
> +Each clock is assigned an identifier and client nodes can use this identifier
> +to specify the clock which they consume.
> +
> +All available clocks are defined as preprocessor macros in
> +dt-bindings/clock/exynos5433.h header and can be used in device
> +tree sources.
> +
> +Example 1: Examples of clock controller nodes are listed below.
> +
> +	cmu_top: clock-controller@0x10030000 {
> +		compatible = "samsung,exynos5433-cmu-top";
> +		reg = <0x10030000 0x0c04>;
> +		#clock-cells = <1>;
> +	};
> +
> +	cmu_cpif: clock-controller@0x10fc0000 {
> +		compatible = "samsung,exynos5433-cmu-cpif";
> +		reg = <0x10fc0000 0x0c04>;
> +		#clock-cells = <1>;
> +	};
> +
> +	cmu_mif: clock-controller@0x105b0000 {
> +		compatible = "samsung,exynos5433-cmu-mif";
> +		reg = <0x105b0000 0x100c>;
> +		#clock-cells = <1>;
> +	};
> +
> +	cmu_peric: clock-controller@0x14c80000 {
> +		compatible = "samsung,exynos5433-cmu-peric";
> +		reg = <0x14c80000 0x0b08>;
> +		#clock-cells = <1>;
> +	};
> +
> +	cmu_peris: clock-controller@0x10040000 {
> +		compatible = "samsung,exynos5433-cmu-peris";
> +		reg = <0x10040000 0x0b20>;
> +		#clock-cells = <1>;
> +	};
> +
> +	cmu_fsys: clock-controller@0x156e0000 {
> +		compatible = "samsung,exynos5433-cmu-fsys";
> +		reg = <0x156e0000 0x0b04>;
> +		#clock-cells = <1>;
> +	};

What are the reasons to split the whole clock controller into separate
device nodes with different compatible strings like this? I doubt drivers
associated with each of those compatible strings could be ever reused on
different Exynos SoCs.

There are hardware dependencies between these clock domains, which are
not currently modelled in DT with your binding. IOW, there is currently
no way to ensure proper registration order of the CMUs (clock domains).
This may be important in some cases.

To address this we could either add clocks/clock-names properties in
respective CMU device nodes, pointing to any clocks in other CMU(s) or
make a single device node for the whole clock controller, with an
aggregated reg entry, e.g.

 cmu: clock-controller@0x10030000 {
	compatible = "samsung,exynos5433-cmu";
	reg =   <0x10030000 0x0c04>,
		<0x10fc0000 0x0c04>,
		<0x105b0000 0x100c>,
		<0x14c80000 0x0b08>,
		<0x10040000 0x0b20>,
		<0x156e0000 0x0b04>,
			...
	reg-names = "top", "cpif", "mif", "peric", "peris", "fsys"...
	#clock-cells = <1>;
 };

Then we could modify samsung_cmu_register_one() function by adding
the reg entry index or name argument. What do you think ?

--
Regards,
Sylwester
