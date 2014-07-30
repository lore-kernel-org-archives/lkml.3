Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbaG3SMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 14:12:21 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:61958 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbaG3SMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 14:12:18 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:2811:8aec:a585:9833]
In-Reply-To: <1406732794-20920-3-git-send-email-rric@kernel.org>
References: <1406732794-20920-1-git-send-email-rric@kernel.org>
	<1406732794-20920-3-git-send-email-rric@kernel.org>
Date: Wed, 30 Jul 2014 11:12:17 -0700
Message-ID: <CAOesGMj9PnfddJO7PorZ7U2OoBFBe4LqONRnbJeMiEkQV1mmWw@mail.gmail.com>
Subject: Re: [PATCH 2/5] arm64, thunder: Add initial dts for Cavium Thunder SoC
From: Olof Johansson <olof@lixom.net>
To: Robert Richter <rric@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Robert Richter <rrichter@cavium.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 8:06 AM, Robert Richter <rric@kernel.org> wrote:
> From: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
>
> Add initial device tree nodes for Cavium Thunder SoCs with support of
> 48 cores and gicv3. The dts file requires further changes, esp. for
> pci, gicv3-its and smmu. This changes will be added later together
> with the device drivers.
>
> Signed-off-by: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> Signed-off-by: Robert Richter <rrichter@cavium.com>
> ---
>  arch/arm64/boot/dts/Makefile         |   1 +
>  arch/arm64/boot/dts/thunder-88xx.dts | 387 +++++++++++++++++++++++++++++++++++
>  2 files changed, 388 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/thunder-88xx.dts
>
> diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
> index c52bdb051f66..f8001a62029c 100644
> --- a/arch/arm64/boot/dts/Makefile
> +++ b/arch/arm64/boot/dts/Makefile
> @@ -1,3 +1,4 @@
> +dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
>  dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
>  dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
>
> diff --git a/arch/arm64/boot/dts/thunder-88xx.dts b/arch/arm64/boot/dts/thunder-88xx.dts
> new file mode 100644
> index 000000000000..4cf20ac9138b
> --- /dev/null
> +++ b/arch/arm64/boot/dts/thunder-88xx.dts
> @@ -0,0 +1,387 @@
> +/*
> + * Cavium Thunder DTS file
> + *
> + * Copyright (C) 2013, Cavium Inc.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + */
> +/dts-v1/;
> +
> +/* Reserving first 12MB of DDR for firmware */
> +/memreserve/ 0x00000000 0x00c00000;
> +
> +/ {
> +       model = "Cavium ThunderX CN88XX Family";
> +       compatible = "cavium,thunder-88xx";

Hmm. I take it this platform is compliant with some level of SBSA? We
should probably have a compatible value for that so that platforms can
communicate it.

Mark, are there already plans for this?


-Olof
