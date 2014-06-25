Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbaFYMVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:21:41 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:48605 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbaFYMVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:21:39 -0400
MIME-Version: 1.0
In-Reply-To: <1403692675-26503-1-git-send-email-marc.zyngier@arm.com>
References: <1403692675-26503-1-git-send-email-marc.zyngier@arm.com>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 25 Jun 2014 07:21:17 -0500
Message-ID: <CAL_Jsq+rS3FE8_F-4qdUUTaJ6X9XNFP2d2h7CdU9hDRG0KG9uA@mail.gmail.com>
Subject: Re: [PATCH] arm/arm64: DT: Fix GICv2 CPU interface size
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        =?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 5:37 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> All the Cortex-{A7,A15} implementations are using a GICv2. Same for
> the current arm64 platforms.
>
> Turns out that most of these platforms have described their GIC CPU
> interface size as being 4kB. while it is actually 8kB (the GICC_DIR
> register lives at offset 0x1000).
>
> This was found when converting the GIC driver to use EOImode==1 on
> GICv2-based systems. It uses the GICC_DIR register, and the result
> is a very early firework...

What's your plan for making the kernel change? Updating the dts files
is good, but that doesn't immediately help you if you have old dtbs.

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/boot/dts/axm55xx.dtsi              | 2 +-
>  arch/arm/boot/dts/dra7.dtsi                 | 2 +-
>  arch/arm/boot/dts/ecx-2000.dts              | 2 +-

Acked-by: Rob Herring <robh@kernel.org>

Rob
