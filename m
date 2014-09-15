Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaIOPJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:09:14 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:34344 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaIOPJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:09:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140915144803.GL18566@dragon>
References: <cover.1410253534.git.shengjiu.wang@freescale.com>
	<7ed21195ebff8b3ccbecaeb492504edd28deea2d.1410253534.git.shengjiu.wang@freescale.com>
	<CAOMZO5A4FLbA_+u4oMTqgAY69DaF93V=oLiy+op=tEHbagF1pg@mail.gmail.com>
	<CAOMZO5DJZHKAV4Y9aUwMNWZqhoLrKrsZdYnKqPem2ZSy=-oAYw@mail.gmail.com>
	<20140915115855.GC23877@audiosh1>
	<20140915144803.GL18566@dragon>
Date: Mon, 15 Sep 2014 12:09:10 -0300
Message-ID: <CAOMZO5DOPgLz3UMvVbJh33AuQfbs0G7XTCvTnVePHrpSyXiHiQ@mail.gmail.com>
Subject: Re: [PATCH V1 1/3] ARM: clk-imx6sl: refine clock tree for SSI
From: Fabio Estevam <festevam@gmail.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Shengjiu Wang <shengjiu.wang@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 11:48 AM, Shawn Guo <shawn.guo@freescale.com> wrote:

> Shengjiu,
>
> Your analysis is right.  I hope the following change will get the shared
> gate clock code eventually does the right thing.
>
> Shawn
>
> diff --git a/arch/arm/mach-imx/clk-gate2.c b/arch/arm/mach-imx/clk-gate2.c
> index 84acdfd1d715..89abdf738dc9 100644
> --- a/arch/arm/mach-imx/clk-gate2.c
> +++ b/arch/arm/mach-imx/clk-gate2.c
> @@ -97,7 +97,7 @@ static int clk_gate2_is_enabled(struct clk_hw *hw)
>         struct clk_gate2 *gate = to_clk_gate2(hw);
>
>         if (gate->share_count)
> -               return !!(*gate->share_count);
> +               return !!__clk_get_enable_count(hw->clk);
>         else
>                 return clk_gate2_reg_is_enabled(gate->reg, gate->bit_idx);

This fixes the audio playback, thanks. Tested on a mx6qsabresd and
also on mx6sx sdb:

Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
