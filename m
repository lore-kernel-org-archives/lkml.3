Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaLUX1e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 18:27:34 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:44881 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaLUX1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 18:27:33 -0500
X-Auth-Info: N22NACRmtEXsek4dacXJGRhePQHUH009gg55DyUsQy0=
From: Marek Vasut <marex@denx.de>
To: Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH] clk: mxs: Fix invalid 32-bit access to frac registers
Date: Sun, 21 Dec 2014 22:50:15 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: mturquette@linaro.org, festevam@gmail.com, shawn.guo@linaro.org,
        harald@ccbib.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1419169599-24791-1-git-send-email-stefan.wahren@i2se.com>
In-Reply-To: <1419169599-24791-1-git-send-email-stefan.wahren@i2se.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201412212250.16007.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 21, 2014 at 02:46:39 PM, Stefan Wahren wrote:

Hi!

[...]

> diff --git a/drivers/clk/mxs/clk-ref.c b/drivers/clk/mxs/clk-ref.c
> index 4adeed6..bdecec1 100644
> --- a/drivers/clk/mxs/clk-ref.c
> +++ b/drivers/clk/mxs/clk-ref.c
> @@ -16,6 +16,8 @@
>  #include <linux/slab.h>
>  #include "clk.h"
> 
> +#define BF_CLKGATE	BIT(7)
> +
>  /**
>   * struct clk_ref - mxs reference clock
>   * @hw: clk_hw for the reference clock
> @@ -39,7 +41,7 @@ static int clk_ref_enable(struct clk_hw *hw)
>  {
>  	struct clk_ref *ref = to_clk_ref(hw);
> 
> -	writel_relaxed(1 << ((ref->idx + 1) * 8 - 1), ref->reg + CLR);
> +	writeb(BF_CLKGATE, ref->reg + ref->idx + CLR);

Should this be writeb_relaxed() maybe ?

>  	return 0;
>  }
> @@ -48,7 +50,7 @@ static void clk_ref_disable(struct clk_hw *hw)
>  {
>  	struct clk_ref *ref = to_clk_ref(hw);
> 
> -	writel_relaxed(1 << ((ref->idx + 1) * 8 - 1), ref->reg + SET);
> +	writeb(BF_CLKGATE, ref->reg + ref->idx + SET);

Same here and all around the place ?

Other than that, it looks pretty OK :)

Best regards,
Marek Vasut
