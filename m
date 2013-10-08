Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3JHFwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 01:52:53 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46138 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3JHFwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 01:52:49 -0400
MIME-Version: 1.0
In-Reply-To: <20131008143403.c11f294c8a1701a2ab3bc5fd@ops.dti.ne.jp>
References: <20131008143040.52f36df8edb7ab63224d8433@ops.dti.ne.jp>
	<20131008143403.c11f294c8a1701a2ab3bc5fd@ops.dti.ne.jp>
Date: Tue, 8 Oct 2013 14:52:47 +0900
Message-ID: <CANqRtoTPoR8Lt67Bo-BC9DxdN_+XH5uEGBetYGHMnrmjYk-21w@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ARM: shmobile: kzm9d: Use common clock framework
From: Magnus Damm <magnus.damm@gmail.com>
To: takasi-y@ops.dti.ne.jp
Cc: SH-Linux <linux-sh@vger.kernel.org>, Ben Dooks <ben.dooks@codethink.co.uk>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Mike Turquette <mturquette@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 2:34 PM,  <takasi-y@ops.dti.ne.jp> wrote:
> Use common clock framework version of clock
>  drivers/clk/shmobile/clk-emev2.c
> instead of sh-clkfwk version
>  arch/arm/mach-shmobile/clock-emev2.c
> when it is configured as a part of multi-platform.
>
> Signed-off-by: Takashi Yoshii <takasi-y@ops.dti.ne.jp>
> ---
>  arch/arm/mach-shmobile/board-kzm9d-reference.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/mach-shmobile/board-kzm9d-reference.c b/arch/arm/mach-shmobile/board-kzm9d-reference.c
> index 054d8d5..853003c 100644
> --- a/arch/arm/mach-shmobile/board-kzm9d-reference.c
> +++ b/arch/arm/mach-shmobile/board-kzm9d-reference.c
> @@ -20,15 +20,14 @@
>
>  #include <linux/init.h>
>  #include <linux/of_platform.h>
> +#include <linux/clk-provider.h>
>  #include <mach/emev2.h>
>  #include <mach/common.h>
>  #include <asm/mach/arch.h>
>
>  static void __init kzm9d_add_standard_devices(void)
>  {
> -       if (!IS_ENABLED(CONFIG_COMMON_CLK))
> -               emev2_clock_init();
> -
> +       of_clk_init(NULL);

Hi Yoshii-san,

Thanks, this looks very good. It is the correct way now when
renesas-devel-20131008 includes the following series:
[PATCH 00/05] ARM: shmobile: KZM9D Multiplatform update

Acked-by: Magnus Damm <damm@opensource.se>

Cheers,

/ magnus
