Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbaK0LW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:22:26 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39503 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645AbaK0LVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:21:16 -0500
Date: Thu, 27 Nov 2014 11:21:13 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "olof@lixom.net" <olof@lixom.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "chanho61.park@samsung.com" <chanho61.park@samsung.com>,
        "geunsik.lim@samsung.com" <geunsik.lim@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
        "a.kesavan@samsung.com" <a.kesavan@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 02/19] clk: samsung: Add binding documentation for
 Exynos5433 clock controller
Message-ID: <20141127112113.GC857@leverpostej>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
 <1417073716-22997-3-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417073716-22997-3-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 07:34:59AM +0000, Chanwoo Choi wrote:
> This patch add binding documentation for Exynos5433 clock controller.
> Exynos5433 has various clock domains So, this documentation explains
> the detailed clock domains ans usage guide.
> 
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
> ---
>  .../devicetree/bindings/clock/exynos5433-clock.txt | 106 +++++++++++++++++++++
>  1 file changed, 106 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/exynos5433-clock.txt
> 
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

That header should be added as part of this patch, otehrwise this is
incomplete.

Mark.
