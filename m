Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab3BELRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:17:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35563 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab3BELRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:17:02 -0500
Date: Tue, 5 Feb 2013 11:15:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2] clk: Add composite clock type
Message-ID: <20130205111522.GJ17786@n2100.arm.linux.org.uk>
References: <1359965482-29655-1-git-send-email-pgaikwad@nvidia.com> <20130204.113739.2227266298512077917.hdoyu@nvidia.com> <5110C3E5.2010503@nvidia.com> <20130205.122252.570646990867457667.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130205.122252.570646990867457667.hdoyu@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 11:22:52AM +0100, Hiroshi Doyu wrote:
> diff --git a/drivers/clk/clk-composite.c b/drivers/clk/clk-composite.c
> index f30fb4b..8f88805 100644
> --- a/drivers/clk/clk-composite.c
> +++ b/drivers/clk/clk-composite.c
> @@ -27,6 +27,9 @@ static u8 clk_composite_get_parent(struct clk_hw *hw)
>         const struct clk_ops *mux_ops = composite->mux_ops;
>         struct clk_hw *mux_hw = composite->mux_hw;
>  
> +       if (!mux_hw->clk)
> +	       return -EINVAL;
> +
>         mux_hw->clk = hw->clk;

That just looks totally wrong.

Firstly, according to the hunk, this function has the prototype:

static u8 clk_composite_get_parent(struct clk_hw *hw)

What do you think is the effect of passing -EINVAL back as a 'u8' ?

Secondly, the whole "check mux_hw->clk for NULL, and then overwrite it"
looks really really really wrong.  If it's already set, then why does it
need to be changed?  If it isn't set, why do you need to error out?

Thirdly, why is a function called "get_parent" modifying anything (isn't
it supposed to be _get_ing something?
