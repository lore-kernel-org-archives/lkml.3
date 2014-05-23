Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaEWVTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:19:39 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59265 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaEWVTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:19:36 -0400
Message-ID: <537FBB61.6070201@gmail.com>
Date: Fri, 23 May 2014 23:19:29 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tarek Dakhran <t.dakhran@samsung.com>, linux-kernel@vger.kernel.org
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tarek Dakhran <t.dakhran@gmail.com>
Subject: Re: [PATCH v10 2/3] clk: exynos5410: register clocks using common
 clock framework
References: <1400841343-6016-1-git-send-email-t.dakhran@samsung.com> <1400841343-6016-3-git-send-email-t.dakhran@samsung.com>
In-Reply-To: <1400841343-6016-3-git-send-email-t.dakhran@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tarek,

Thanks for keeping up with addressing my comments. See below.

On 23.05.2014 12:35, Tarek Dakhran wrote:
> The EXYNOS5410 clocks are statically listed and registered
> using the Samsung specific common clock helper functions.
> 
> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
> ---
>  .../devicetree/bindings/clock/exynos5410-clock.txt |   51 +++++
>  drivers/clk/samsung/Makefile                       |    1 +
>  drivers/clk/samsung/clk-exynos5410.c               |  209 ++++++++++++++++++++
>  include/dt-bindings/clock/exynos5410.h             |   33 ++++
>  4 files changed, 294 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
>  create mode 100644 drivers/clk/samsung/clk-exynos5410.c
>  create mode 100644 include/dt-bindings/clock/exynos5410.h
> 

The driver itself looks good, but binding documentation seems to be
outdated. The part about external clocks, more specifically.

> diff --git a/Documentation/devicetree/bindings/clock/exynos5410-clock.txt b/Documentation/devicetree/bindings/clock/exynos5410-clock.txt
> new file mode 100644
> index 0000000..82337c4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/exynos5410-clock.txt
> @@ -0,0 +1,51 @@
> +* Samsung Exynos5410 Clock Controller
> +
> +The Exynos5410 clock controller generates and supplies clock to various
> +controllers within the Exynos5410 SoC.
> +
> +Required Properties:
> +
> +- compatible: should be "samsung,exynos5410-clock"
> +
> +- reg: physical base address of the controller and length of memory mapped
> +  region.
> +
> +- #clock-cells: should be 1.
> +
> +All available clocks are defined as preprocessor macros in
> +dt-bindings/clock/exynos5410.h header and can be used in device
> +tree sources.
> +
> +External clock:
> +There is clock that is generated outside the SoC. It is expected
> +that it is defined using standard clock bindings with following
> + - compatible: should be "samsung,exynos5410-oscclk"

^^^^^

> +
> +Example 1: An example of a clock controller node is listed below.
> +
> +	clock: clock-controller@0x10010000 {
> +		compatible = "samsung,exynos5410-clock";
> +		reg = <0x10010000 0x30000>;
> +		#clock-cells = <1>;
> +	};
> +
> +Example 2: Required external clock.
> +
> +	fixed-rate-clocks {
> +		oscclk {
> +			compatible = "samsung,exynos5410-oscclk";
> +			clock-frequency = <24000000>;
> +		};
> +	};

^^^^^

Best regards,
Tomasz
