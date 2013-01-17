Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab3AQFDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 00:03:37 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18164 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab3AQFDf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 00:03:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 16 Jan 2013 21:03:34 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 17 Jan 2013 06:03:27 +0100
Subject: Re: [PATCH v4 2/9] clk: tegra: Add tegra specific clocks
Thread-Topic: [PATCH v4 2/9] clk: tegra: Add tegra specific clocks
Thread-Index: Ac30b/4ZwasueALuQyqCz4H6HLk5Zw==
Message-ID: <20130117.070327.1625310713330263780.hdoyu@nvidia.com>
References: <1357890387-23245-3-git-send-email-pgaikwad@nvidia.com><20130116.171242.2189136612266237422.hdoyu@nvidia.com><50F7096C.7020803@wwwdotorg.org>
In-Reply-To: <50F7096C.7020803@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren <swarren@wwwdotorg.org> wrote @ Wed, 16 Jan 2013 21:11:24 +0100:

> >> +static int clk_frac_div_set_rate(struct clk_hw *hw, unsigned long rate,
> >> +                               unsigned long parent_rate)
> >> +{
> >> +       struct tegra_clk_frac_div *divider = to_clk_frac_div(hw);
> >> +       int div;
> >> +       unsigned long flags = 0;
> > 
> > nit, is "flags" not needed to initialize here?
> 
> It avoids a compiler warning; the compiler doesn't that the if condition
> that guards the path that uses flags is the same condition as the path
> that initializes it. Or, it may be related to the fact that
> spin_lock_irqsave() writes to the value through a pointer parameter, and
> the compiler doesn't know it's an out-only parameter.

It might be better to append the special comment /* GCC */[1] on that line.

[1] https://lwn.net/Articles/529954/
