Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbaIDSBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 14:01:14 -0400
Received: from gloria.sntech.de ([95.129.55.99]:41734 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbaIDSBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 14:01:12 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Chris Zhong <zyw@rock-chips.com>, dianders@chromium.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        a.zummo@towertech.it, mturquette@linaro.org, akpm@linux-foundation.org,
        broonie@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        grant.likely@linaro.org, hl@rock-chips.com, huangtao@rock-chips.com,
        cf@rock-chips.com, zhangqing@rock-chips.com, xxx@rock-chips.com,
        olof@lixom.net, sonnyrao@chromium.org, javier.martinez@collabora.co.uk,
        kever.yang@rock-chips.com
Subject: Re: [PATCH v9 2/3] clk: RK808: Add clkout driver for RK808
Date: Thu, 04 Sep 2014 20:02:56 +0200
Message-ID: <3708545.id8zLgF0vo@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140904174024.GD10224@core.coreip.homeip.net>
References: <1409793159-2573-1-git-send-email-zyw@rock-chips.com> <1409793159-2573-3-git-send-email-zyw@rock-chips.com> <20140904174024.GD10224@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 4. September 2014, 10:40:24 schrieb Dmitry Torokhov:
> Hi Chris,
> 
> On Thu, Sep 04, 2014 at 09:12:38AM +0800, Chris Zhong wrote:
> > +	rk808_clkout->clk_data.clks = clk_table;
> > +	rk808_clkout->clk_data.clk_num = RK808_NR_OUTPUT;
> > +
> > +	return of_clk_add_provider(node, of_clk_src_onecell_get,
> > +				   &rk808_clkout->clk_data);
> > +}
> > +
> > +static struct platform_driver rk808_clkout_driver = {
> > +	.probe = rk808_clkout_probe,
> > +	.driver		= {
> > +		.name	= "rk808-clkout",
> > +	},
> > +};
> 
> Shouldn't there also be:
> 
> static int rk808_clkout_probe(struct platform_device *pdev)
					^^ remove

Just to prevent confusion. And you're right there of course.


Heiko

> {
> 	of_clk_del_provider(pdev->dev.of_node);
> 
> 	/* The rest of resources are managed ones */
> 
> 	return 0;
> }
> 
> Thanks.

