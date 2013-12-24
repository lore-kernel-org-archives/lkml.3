Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab3LXPHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 10:07:46 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:59565 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab3LXPHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 10:07:45 -0500
X-Auth-Info: KCm9yIaWidfEnuuCaLLCLS5ro2us2v6iX2+23y6Krj0=
Date: Tue, 24 Dec 2013 16:07:41 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-arm-msm@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 03/15] clk: Add regmap core helpers for
 enable/disable/is_enabled
Message-ID: <20131224150741.GG8064@book.gsilab.sittig.org>
Mail-Followup-To: Stephen Boyd <sboyd@codeaurora.org>,
	Mike Turquette <mturquette@linaro.org>,
	linux-arm-msm@vger.kernel.org, Mark Brown <broonie@kernel.org>,
	Saravana Kannan <skannan@codeaurora.org>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1387847559-18330-1-git-send-email-sboyd@codeaurora.org>
 <1387847559-18330-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387847559-18330-4-git-send-email-sboyd@codeaurora.org>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 17:12 -0800, Stephen Boyd wrote:
> 
> The clock framework already has support for simple gate clocks
> but if drivers want to use the gate clock functionality they need
> to wrap the gate clock in another struct and chain the ops by
> calling the gate ops from their own custom ops. Plus the gate
> clock implementation only supports MMIO accessors so other bus
> type clocks don't benefit from the potential code reuse. Add some
> simple regmap helpers for enable/disable/is_enabled that drivers
> can use as drop in replacements for their clock ops or as simple
> functions they call from their own custom ops. This is based on 
> similar helps in the regulator framework.

The same comment applies as to the previous version.  Is it
useful to introduce copies of the gate handling while the
difference in only in how the hardware registers get accessed?

> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -177,11 +177,21 @@ struct clk_init_data {
> [ ... ]
> @@ -447,6 +457,9 @@ struct clk *__clk_lookup(const char *name);
>  long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
>  			      unsigned long *best_parent_rate,
>  			      struct clk **best_parent_p);
> +int clk_is_enabled_regmap(struct clk_hw *hw);
> +int clk_enable_regmap(struct clk_hw *hw);
> +void clk_disable_regmap(struct clk_hw *hw);

Looking at the patch:  Do you expect callers to remember whether
a clock gate is backed by mmio or by regmap access, to call a
different set of routines?  Should this not be hidden behind the
API and be transparent after clock registration?

I'd suggest to fold regmap support into Tero Kristo's ll_ops
approach, and to discuss this in his v12 thread.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
