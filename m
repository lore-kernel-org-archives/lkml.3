Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaCNOjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:39:43 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:32953 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031AbaCNOjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:39:39 -0400
MIME-Version: 1.0
In-Reply-To: <1394780261-6030-1-git-send-email-linus.walleij@linaro.org>
References: <1394780261-6030-1-git-send-email-linus.walleij@linaro.org>
Date: Fri, 14 Mar 2014 07:39:38 -0700
Message-ID: <CAJAp7OjoWyvK5bzoU_Z=n8HGDp=4=PZ-vdfvFYxDPCgKCe560w@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: msm: fix up out-of-order merge conflict
From: Bjorn Andersson <bjorn@kryo.se>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 11:57 PM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> Commit 051a58b4622f0e1b732acb750097c64bc00ddb93
> "pinctrl: msm: Simplify msm_config_reg() and callers"
> removed the local "reg" variable in the msm_config_reg()
> function, but the earlier
> commit ed118a5fd951bd2def8249ee251842c4f81fe4bd
> "pinctrl-msm: Support output-{high,low} configuration"
> introduced a new switchclause using it.
>
> Fix this up by removing the offending register assignment.
>
> Reported-by: Kbuild test robot <fengguang.wu@intel.com>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/pinctrl/pinctrl-msm.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
> index 19d2feb0674f..343f421c7696 100644
> --- a/drivers/pinctrl/pinctrl-msm.c
> +++ b/drivers/pinctrl/pinctrl-msm.c
> @@ -215,7 +215,6 @@ static int msm_config_reg(struct msm_pinctrl *pctrl,
>                 *mask = 7;
>                 break;
>         case PIN_CONFIG_OUTPUT:
> -               *reg = g->ctl_reg;
>                 *bit = g->oe_bit;
>                 *mask = 1;
>                 break;

Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
