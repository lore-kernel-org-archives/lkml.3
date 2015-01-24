Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbbAXQL7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 11:11:59 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:51872 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbbAXQL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 11:11:56 -0500
MIME-Version: 1.0
In-Reply-To: <54C129B0.1090404@samsung.com>
References: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
	<1421821618-8627-2-git-send-email-cw00.choi@samsung.com>
	<54C129B0.1090404@samsung.com>
Date: Sun, 25 Jan 2015 01:11:55 +0900
Message-ID: <CA+Ln22Ej5VZQq0d9tmZ8RYPSrTyshETecXanVEj_iPSrX3Tm1A@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] clk: samsung: exynos5433: Add clocks using
 common clock framework
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Michael Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene@kernel.org>, Pankaj Dubey <pankaj.dubey@samsung.com>,
        InKi Dae <inki.dae@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>,
        "sw0312.kim" <sw0312.kim@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-23 1:47 GMT+09:00 Sylwester Nawrocki <s.nawrocki@samsung.com>:
> Hi Chanwoo,
>
> On 21/01/15 07:26, Chanwoo Choi wrote:
>> This patch adds the support for CMU (Clock Management Units) of Exynos5433
>> which is 64bit SoC and has Octa-cores. This patch supports necessary clocks
>> (PLL/MMC/UART/MCT/I2C/SPI) for kernel boot and includes binding documentation
>> for Exynos5433 clock controller.
>
>> diff --git a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
>> new file mode 100644
>> index 0000000..72cd0ba
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
>> @@ -0,0 +1,106 @@
>> +* Samsung Exynos5433 CMU (Clock Management Units)
>> +
>> +The Exynos5433 clock controller generates and supplies clock to various
>> +controllers within the Exynos5433 SoC.
>> +
>> +Required Properties:
>> +
>> +- compatible: should be one of the following.
>> +  - "samsung,exynos5433-cmu-top"   - clock controller compatible for CMU_TOP
>> +    which generates clocks for IMEM/FSYS/G3D/GSCL/HEVC/MSCL/G2D/MFC/PERIC/PERIS
>> +    domains and bus clocks.
>> +  - "samsung,exynos5433-cmu-cpif"  - clock controller compatible for CMU_CPIF
>> +    which generates clocks for LLI (Low Latency Interface) IP.
>> +  - "samsung,exynos5433-cmu-mif"   - clock controller compatible for CMU_MIF
>> +    which generates clocks for DRAM Memory Controller domain.
>> +  - "samsung,exynos5433-cmu-peric" - clock controller compatible for CMU_PERIC
>> +    which generates clocks for UART/I2C/SPI/I2S/PCM/SPDIF/PWM/SLIMBUS IPs.
>> +  - "samsung,exynos5433-cmu-peris" - clock controller compatible for CMU_PERIS
>> +    which generates clocks for PMU/TMU/MCT/WDT/RTC/SECKEY/TZPC IPs.
>> +  - "samsung,exynos5433-cmu-fsys"  - clock controller compatible for CMU_FSYS
>> +    which generates clocks for USB/UFS/SDMMC/TSI/PDMA IPs.
>> +
>> +- reg: physical base address of the controller and length of memory mapped
>> +  region.
>> +
>> +- #clock-cells: should be 1.
>> +
>> +Each clock is assigned an identifier and client nodes can use this identifier
>> +to specify the clock which they consume.
>> +
>> +All available clocks are defined as preprocessor macros in
>> +dt-bindings/clock/exynos5433.h header and can be used in device
>> +tree sources.
>> +
>> +Example 1: Examples of clock controller nodes are listed below.
>> +
>> +     cmu_top: clock-controller@0x10030000 {
>> +             compatible = "samsung,exynos5433-cmu-top";
>> +             reg = <0x10030000 0x0c04>;
>> +             #clock-cells = <1>;
>> +     };
>> +
>> +     cmu_cpif: clock-controller@0x10fc0000 {
>> +             compatible = "samsung,exynos5433-cmu-cpif";
>> +             reg = <0x10fc0000 0x0c04>;
>> +             #clock-cells = <1>;
>> +     };
>> +
>> +     cmu_mif: clock-controller@0x105b0000 {
>> +             compatible = "samsung,exynos5433-cmu-mif";
>> +             reg = <0x105b0000 0x100c>;
>> +             #clock-cells = <1>;
>> +     };
>> +
>> +     cmu_peric: clock-controller@0x14c80000 {
>> +             compatible = "samsung,exynos5433-cmu-peric";
>> +             reg = <0x14c80000 0x0b08>;
>> +             #clock-cells = <1>;
>> +     };
>> +
>> +     cmu_peris: clock-controller@0x10040000 {
>> +             compatible = "samsung,exynos5433-cmu-peris";
>> +             reg = <0x10040000 0x0b20>;
>> +             #clock-cells = <1>;
>> +     };
>> +
>> +     cmu_fsys: clock-controller@0x156e0000 {
>> +             compatible = "samsung,exynos5433-cmu-fsys";
>> +             reg = <0x156e0000 0x0b04>;
>> +             #clock-cells = <1>;
>> +     };
>
> What are the reasons to split the whole clock controller into separate
> device nodes with different compatible strings like this? I doubt drivers
> associated with each of those compatible strings could be ever reused on
> different Exynos SoCs.

Well, they are separate IP blocks, so this is how they should be
represented in DT and IMHO using different compatible strings is a bit
cleaner than relying on aliases to get instance index.

Plus we probably want to learn from mistakes done when designing
Exynos4x12 clock bindings, which prevent us from fixing the issue of
ISP power domain, in which the ISP CMU is located. AFAICS, Exynos5433
clock tree is split between several such "ISP CMUs".

>
> There are hardware dependencies between these clock domains, which are
> not currently modelled in DT with your binding. IOW, there is currently
> no way to ensure proper registration order of the CMUs (clock domains).
> This may be important in some cases.
>
> To address this we could either add clocks/clock-names properties in
> respective CMU device nodes, pointing to any clocks in other CMU(s)

which I believe is the proper way of doing things, which lets us
preserve the correct representation of separate CMUs in DT.

Best regards,
Tomasz
