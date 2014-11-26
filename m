Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaKZKak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 05:30:40 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:39545 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaKZKai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 05:30:38 -0500
Message-ID: <5475ABC0.3090007@arm.com>
Date: Wed, 26 Nov 2014 10:30:24 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Liviu Dudau <Liviu.Dudau@arm.com>, "arm@kernel.org" <arm@kernel.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        device tree <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 2/2] arm64: Add Juno board device tree.
References: <1415727131-4572-1-git-send-email-Liviu.Dudau@arm.com> <1415727131-4572-3-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1415727131-4572-3-git-send-email-Liviu.Dudau@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liviu,

On 11/11/14 17:32, Liviu Dudau wrote:
> This adds support for ARM's Juno development board (rev 0).
> It enables most of the board peripherals: UART, I2C, USB, MMC and
> 100Mb ethernet. There is no support at the moment for clock setting
> and HDLCD driver which depends on it.
> 
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> ---
>  arch/arm64/boot/dts/arm/Makefile              |   1 +
>  arch/arm64/boot/dts/arm/juno-clocks.dtsi      |  45 ++++++
>  arch/arm64/boot/dts/arm/juno-motherboard.dtsi | 129 +++++++++++++++
>  arch/arm64/boot/dts/arm/juno.dts              | 218 ++++++++++++++++++++++++++
>  4 files changed, 393 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/arm/juno-clocks.dtsi
>  create mode 100644 arch/arm64/boot/dts/arm/juno-motherboard.dtsi
>  create mode 100644 arch/arm64/boot/dts/arm/juno.dts
> 

[...]

> diff --git a/arch/arm64/boot/dts/arm/juno.dts b/arch/arm64/boot/dts/arm/juno.dts
> new file mode 100644
> index 0000000..097ecc4
> --- /dev/null
> +++ b/arch/arm64/boot/dts/arm/juno.dts

[...]

> +       timer {
> +               compatible = "arm,armv8-timer";
> +               interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
> +                            <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
> +                            <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
> +                            <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>;
> +       };

Sorry, I should have spotted this earlier: all these interrupts are
*level*, not edge. This happens to work because the GIC's config
register is RO for PPIs on Juno, but still...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
