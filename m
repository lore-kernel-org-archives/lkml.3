Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934853AbaE2RwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:52:18 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:52369 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934810AbaE2RwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:52:15 -0400
MIME-Version: 1.0
In-Reply-To: <1401345500-20188-17-git-send-email-kishon@ti.com>
References: <1401345500-20188-1-git-send-email-kishon@ti.com>
	<1401345500-20188-17-git-send-email-kishon@ti.com>
Date: Thu, 29 May 2014 12:52:14 -0500
Message-ID: <CAL_JsqJifZqs9MpL=n4FRB+Z1OMtkw0sns8Vwec=_boGqRL8-w@mail.gmail.com>
Subject: Re: [PATCH v2 16/18] ARM: OMAP: Enable PCI for DRA7
From: Rob Herring <robherring2@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Jingoo Han <jg1.han@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 1:38 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Now that we have added PCIe driver for DRA7 SOCs, enable PCI on
> DRA7 SOCs.
>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Kumar Gala <galak@codeaurora.org>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/mach-omap2/Kconfig |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index cb31d43..b179e80 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -75,6 +75,8 @@ config SOC_DRA7XX
>         select ARM_GIC
>         select HAVE_ARM_ARCH_TIMER
>         select IRQ_CROSSBAR
> +       select MIGHT_HAVE_PCI

I believe we moved or intend to move this under MULTI_PLATFORM, so you
don't need this. Will D. had a patch, but I don't think I saw a final
version to merge.

Rob

> +       select ARCH_SUPPORTS_MSI
>
>  config ARCH_OMAP2PLUS
>         bool
> --
> 1.7.9.5
>
