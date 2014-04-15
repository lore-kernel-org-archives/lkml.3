Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaDOMnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:43:06 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:12133 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751951AbaDOMnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:43:03 -0400
Message-ID: <534D294D.7000201@arm.com>
Date: Tue, 15 Apr 2014 13:42:53 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Anders Berg <anders.berg@lsi.com>
CC: "arnd@arndb.de" <arnd@arndb.de>, "olof@lixom.net" <olof@lixom.net>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/5] ARM: dts: Device tree for AXM55xx.
References: <cover.1397552154.git.anders.berg@lsi.com> <02c006a6fc64131df82981abbc1c71c7af52254e.1397552154.git.anders.berg@lsi.com>
In-Reply-To: <02c006a6fc64131df82981abbc1c71c7af52254e.1397552154.git.anders.berg@lsi.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anders,

On 15/04/14 13:06, Anders Berg wrote:
> Add device tree for the Amarillo validation board with an AXM5516 SoC.
> 
> Signed-off-by: Anders Berg <anders.berg@lsi.com>
> ---
>  arch/arm/boot/dts/Makefile             |   1 +
>  arch/arm/boot/dts/axm5516-amarillo.dts |  51 ++++++
>  arch/arm/boot/dts/axm5516-cpus.dtsi    | 204 ++++++++++++++++++++++
>  arch/arm/boot/dts/axm55xx.dtsi         | 306 +++++++++++++++++++++++++++++++++
>  4 files changed, 562 insertions(+)
>  create mode 100644 arch/arm/boot/dts/axm5516-amarillo.dts
>  create mode 100644 arch/arm/boot/dts/axm5516-cpus.dtsi
>  create mode 100644 arch/arm/boot/dts/axm55xx.dtsi
> 

[...]

> +       gic: interrupt-controller@2001001000 {
> +               compatible = "arm,cortex-a15-gic";
> +               #interrupt-cells = <3>;
> +               #address-cells = <0>;
> +               interrupt-controller;
> +               reg = <0x20 0x01001000 0 0x1000>,
> +                     <0x20 0x01002000 0 0x1000>,
> +                     <0x20 0x01004000 0 0x2000>,
> +                     <0x20 0x01006000 0 0x2000>;
> +               interrupts = <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(4) |
> +                               IRQ_TYPE_LEVEL_HIGH)>;
> +       };

Given how many CPUs this system has, what's the catch regarding the GIC?
Is there a second one shadowing this one at the same address for another
set of 8 CPUs? Is there an additional mechanism to IPI the other CPUs?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
