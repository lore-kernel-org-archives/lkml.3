Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3HVWbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 18:31:46 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:55345 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab3HVWbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 18:31:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Jisheng Zhang <jszhang@marvell.com>, <jszhang@marvell.com>,
        <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>,
        <ezequiel.garcia@free-electrons.com>,
        <sebastian.hesselbarth@gmail.com>, <linus.walleij@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1377175611-4241-4-git-send-email-jszhang@marvell.com>
Cc: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <1377175611-4241-1-git-send-email-jszhang@marvell.com>
 <1377175611-4241-4-git-send-email-jszhang@marvell.com>
Message-ID: <20130822223140.8231.74026@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH 3/4] clk: mvebu: add missing iounmap
Date: Thu, 22 Aug 2013 15:31:40 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jisheng Zhang (2013-08-22 05:46:50)
> Add missing iounmap to setup error path.
> 
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>

Patch looks good with one minor nitpick below.

> @@ -145,10 +147,8 @@ void __init mvebu_clk_gating_setup(struct device_node *np,
>         ctrl->num_gates = n;
>         ctrl->gates = kzalloc(ctrl->num_gates * sizeof(struct clk *),
>                               GFP_KERNEL);
> -       if (WARN_ON(!ctrl->gates)) {
> -               kfree(ctrl);
> -               return;
> -       }
> +       if (WARN_ON(!ctrl->gates))
> +               goto bail_out;
>  
>         for (n = 0; n < ctrl->num_gates; n++) {
>                 const char *parent =
> @@ -160,4 +160,10 @@ void __init mvebu_clk_gating_setup(struct device_node *np,
>         }
>  
>         of_clk_add_provider(np, clk_gating_get_src, ctrl);
> +
> +       return;
> +bail_out:
> +       kfree(ctrl);
> +ctrl_out:
> +       iounmap(base);

bail_out is not the best name. How about gates_out?

Regards,
Mike
