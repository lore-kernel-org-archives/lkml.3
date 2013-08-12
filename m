Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab3HLNzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:55:06 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46334 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756176Ab3HLNzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:55:03 -0400
Date: Mon, 12 Aug 2013 14:54:27 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Emilio =?utf-8?B?TMOzcGV6?= <emilio@elopez.com.ar>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kevin.z.m.zh@gmail.com" <kevin.z.m.zh@gmail.com>,
        "sunny@allwinnertech.com" <sunny@allwinnertech.com>,
        "shuge@allwinnertech.com" <shuge@allwinnertech.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/4] clk: sunxi: Add A31 clocks support
Message-ID: <20130812135427.GA27165@e106331-lin.cambridge.arm.com>
References: <1375195462-19566-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375195462-19566-4-git-send-email-maxime.ripard@free-electrons.com>
 <20130812125357.GD6616@e106331-lin.cambridge.arm.com>
 <5208DCB7.9070103@elopez.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5208DCB7.9070103@elopez.com.ar>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 02:01:43PM +0100, Emilio López wrote:
> El 12/08/13 09:53, Mark Rutland escribió:
> > On Tue, Jul 30, 2013 at 03:44:21PM +0100, Maxime Ripard wrote:
> >> The A31 has a mostly different clock set compared to the other older
> >> SoCs currently supported in the Allwinner clock driver.
> >>
> >> Add support for the basic useful clocks. The other ones will come in
> >> eventually.
> >>
> >> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >> ---
> >>  drivers/clk/sunxi/clk-sunxi.c | 120 ++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 120 insertions(+)
> >>
> > 
> > [...]
> > 
> >> @@ -420,6 +516,10 @@ static const __initconst struct of_device_id clk_factors_match[] = {
> >>  		.data = &sun4i_pll1_data,
> >>  	},
> >>  	{
> >> +		.compatible = "allwinner,sun6i-pll1-clk",
> >> +		.data = &sun6i_pll1_data,
> >> +	},
> >> +	{
> >>  		.compatible = "allwinner,sun4i-apb1-clk",
> >>  		.data = &sun4i_apb1_data,
> >>  	},
> >> @@ -440,6 +540,10 @@ static const __initconst struct of_device_id clk_div_match[] = {
> >>  		.compatible = "allwinner,sun4i-apb0-clk",
> >>  		.data = &sun4i_apb0_data,
> >>  	},
> >> +	{
> >> +		.compatible = "allwinner,sun6i-apb2-div-clk",
> >> +		.data = &sun6i_apb2_div_data,
> >> +	},
> >>  	{}
> >>  };
> >>  
> >> @@ -453,6 +557,10 @@ static const __initconst struct of_device_id clk_mux_match[] = {
> >>  		.compatible = "allwinner,sun4i-apb1-mux-clk",
> >>  		.data = &sun4i_apb1_mux_data,
> >>  	},
> >> +	{
> >> +		.compatible = "allwinner,sun6i-ahb1-mux-clk",
> >> +		.data = &sun6i_ahb1_mux_data,
> >> +	},
> >>  	{}
> >>  };
> >>  
> >> @@ -471,6 +579,10 @@ static const __initconst struct of_device_id clk_gates_match[] = {
> >>  		.data = &sun5i_a13_ahb_gates_data,
> >>  	},
> >>  	{
> >> +		.compatible = "allwinner,sun6i-a31-ahb1-gates-clk",
> >> +		.data = &sun6i_a31_ahb1_gates_data,
> >> +	},
> >> +	{
> >>  		.compatible = "allwinner,sun4i-apb0-gates-clk",
> >>  		.data = &sun4i_apb0_gates_data,
> >>  	},
> >> @@ -486,6 +598,14 @@ static const __initconst struct of_device_id clk_gates_match[] = {
> >>  		.compatible = "allwinner,sun5i-a13-apb1-gates-clk",
> >>  		.data = &sun5i_a13_apb1_gates_data,
> >>  	},
> >> +	{
> >> +		.compatible = "allwinner,sun6i-a31-apb1-gates-clk",
> >> +		.data = &sun6i_a31_apb1_gates_data,
> >> +	},
> >> +	{
> >> +		.compatible = "allwinner,sun6i-a31-apb2-gates-clk",
> >> +		.data = &sun6i_a31_apb2_gates_data,
> >> +	},
> >>  	{}
> >>  };
> > 
> > Could you please document these new strings? I assume they follow the
> > general conventions of sunxi clocks thus far and the strings can just be
> > appended to the lists in the existing binding document.
> 
> I believe they have been documented already on the latest version of
> this patchset (v3 at the time of speaking)

Indeed they are, and they look fine. Apologies for the noise.

Thanks,
Mark.
