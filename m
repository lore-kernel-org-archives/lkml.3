Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaILLAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:00:18 -0400
Received: from gloria.sntech.de ([95.129.55.99]:47762 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbaILLAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:00:15 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Mark yao <mark.yao@rock-chips.com>
Cc: Mike Turquette <mturquette@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, djkurtz@chromium.org,
        dianders@chromium.org, dkl@rock-chips.com, eddie.cai@rock-chips.com,
        xjq@rock-chips.com, kfx@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yxj@rock-chips.com, cym@rock-chips.com,
        zhengsq@rock-chips.com, caesar.wang@rock-chips.com,
        kever.yang@rock-chips.com
Subject: Re: [PATCH] clk: rockchip: rk3288: add VOP1 softresets and rename VOP0 softresets
Date: Fri, 12 Sep 2014 12:41:30 +0200
Message-ID: <3298686.YKlhYtF9M9@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1410518004-19040-1-git-send-email-mark.yao@rock-chips.com>
References: <1410518004-19040-1-git-send-email-mark.yao@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Am Freitag, 12. September 2014, 18:33:23 schrieb Mark yao:
> The rk3288 have two vop, and each vop has three softresets were axi_reset,
> ahb_reset and dclk_reset.

I'm not sure about renaming the indices, since they're part of the devicetree-
binding. We know that so far no device in the wild used them, so it might be 
ok.

But in any case could you also add the rest of the indices of the "new" reset 
registers please, so that we don't end up adding each small index in a 
separate patch.

patch1: add reset indices for SOFTRST9 - SOFTRST11
patch2: rename LCDC0 -> VOP0


Heiko

> 
> Signed-off-by: Mark yao <mark.yao@rock-chips.com>
> ---
>  include/dt-bindings/clock/rk3288-cru.h | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/include/dt-bindings/clock/rk3288-cru.h
> b/include/dt-bindings/clock/rk3288-cru.h index ebcb460..4d65959 100644
> --- a/include/dt-bindings/clock/rk3288-cru.h
> +++ b/include/dt-bindings/clock/rk3288-cru.h
> @@ -235,9 +235,9 @@
>  #define SRST_RGA_NIU		97
>  #define SRST_VIO0_NIU_AXI	98
>  #define SRST_VIO_NIU_AHB	99
> -#define SRST_LCDC0_AXI		100
> -#define SRST_LCDC0_AHB		101
> -#define SRST_LCDC0_DCLK		102
> +#define SRST_VOP0_AXI		100
> +#define SRST_VOP0_AHB		101
> +#define SRST_VOP0_DCLK		102
>  #define SRST_VIO1_NIU_AXI	103
>  #define SRST_VIP		104
>  #define SRST_RGA_CORE		105
> @@ -276,3 +276,7 @@
>  #define SRST_USBHOST1_CON	140
>  #define SRST_USB_ADP		141
>  #define SRST_ACC_EFUSE		142
> +
> +#define SRST_VOP1_AXI		176
> +#define SRST_VOP1_AHB		177
> +#define SRST_VOP1_DCLK		178

