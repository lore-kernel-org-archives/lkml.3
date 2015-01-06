Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbbAFH0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 02:26:25 -0500
Received: from smtprelay0182.hostedemail.com ([216.40.44.182]:59372 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750921AbbAFH0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 02:26:24 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3874:4321:5007:6261:8660:9036:10004:10400:10450:10455:10848:11026:11232:11657:11658:11914:12043:12517:12519:12740:13069:13148:13230:13311:13357:14096:14097:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: order89_1a7864cddb32a
X-Filterd-Recvd-Size: 2069
Message-ID: <1420529180.2652.31.camel@perches.com>
Subject: Re: [PATCH] GMAC: fix simple_return.cocci warnings
From: Joe Perches <joe@perches.com>
To: Roger <roger.chen@rock-chips.com>
Cc: David Miller <davem@davemloft.net>, fengguang.wu@intel.com,
        kbuild-all@01.org, peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 05 Jan 2015 23:26:20 -0800
In-Reply-To: <54AB8B23.3080303@rock-chips.com>
References: <201501030822.7cG5bXrm%fengguang.wu@intel.com>
	 <20150103002526.GA15863@waimea.lkp.intel.com>
	 <1420246005.23591.7.camel@perches.com>
	 <20150104.222022.55122203599464788.davem@davemloft.net>
	 <54AB8B23.3080303@rock-chips.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-06 at 15:13 +0800, Roger wrote:
> What should I do now?

I think it would be better to change
"int gmac_clk_enable" to "void gmac_clk_enable"
(it always returns 0)

This function should simply call gmac_clk_enable
and return 0;

> >>> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> >>> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> >>> @@ -422,11 +422,7 @@ static int rk_gmac_init(struct platform_
> >>>   	if (ret)
> >>>   		return ret;
> >>>   
> >>> -	ret = gmac_clk_enable(bsp_priv, true);
> >>> -	if (ret)
> >>> -		return ret;
> >>> -
> >>> -	return 0;
> >>> +	return gmac_clk_enable(bsp_priv, true);
> >> I think this change is not particularly better.
> >>
> >> When the pattern is multiply repeated like:
> >   ...
> >> I think it's better to not change the last
> >> test in the sequence just to minimize overall
> >> line count.
> > I think it's a wash and that both ways are about the same to me.
> >
> > I won't apply this, sorry.


