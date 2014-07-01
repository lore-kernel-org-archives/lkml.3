Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbaGADd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 23:33:29 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:57023 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353AbaGADdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 23:33:21 -0400
MIME-Version: 1.0
In-Reply-To: <1404175210-9278-1-git-send-email-cw00.choi@samsung.com>
References: <1404175210-9278-1-git-send-email-cw00.choi@samsung.com>
Date: Tue, 1 Jul 2014 09:03:18 +0530
Message-ID: <CAK5sBcFJMK-y+MZPXCufKEmp=v1nFJHstvNTczsQ3ez3SUPbKw@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: Add TMU dt node to monitor the temperature for Exynos3250
From: Sachin Kamat <spk.linux@gmail.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Tue, Jul 1, 2014 at 6:10 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> This patch add TMU (Thermal Management Unit) dt node to monitor the high
> temperature for Exynos3250.
>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> This patch has a dependency on following patch [1]:
>  [1] https://lkml.org/lkml/2014/6/30/805
>
>  arch/arm/boot/dts/exynos3250.dtsi | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
> index 3660cab..1e566af 100644
> --- a/arch/arm/boot/dts/exynos3250.dtsi
> +++ b/arch/arm/boot/dts/exynos3250.dtsi
> @@ -192,6 +192,16 @@
>                         status = "disabled";
>                 };
>
> +               tmu: tmu@100C0000 {
> +                       compatible = "samsung,exynos3250-tmu";
> +                       interrupt-parent = <&gic>;
> +                       reg = <0x100C0000 0x100>;
> +                       interrupts = <0 216 0>;
> +                       clocks = <&cmu CLK_TMU_APBIF>;
> +                       clock-names = "tmu_apbif";
> +                       status = "disabled";

I don't think there would be any board specific properties needed. Hence
leave the status as enabled (by deleting the above line).

-- 
Regards,
Sachin.
