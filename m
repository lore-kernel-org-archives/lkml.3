Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab3BFKA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:00:29 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4816 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3BFKA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:00:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 06 Feb 2013 01:59:53 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "t.figa@samsung.com" <t.figa@samsung.com>
Date: Wed, 6 Feb 2013 11:00:14 +0100
Subject: Re: [PATCH V2] clk: Add composite clock type
Thread-Topic: [PATCH V2] clk: Add composite clock type
Thread-Index: Ac4EUMOLXiZHEDB4QG+YBlld3IYF5w==
Message-ID: <20130206.120014.87075843729177552.hdoyu@nvidia.com>
References: <5111C604.8070104@nvidia.com><20130206.081048.71241785637713947.hdoyu@nvidia.com><511227F6.3050601@nvidia.com>
In-Reply-To: <511227F6.3050601@nvidia.com>
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

Prashant Gaikwad <pgaikwad@nvidia.com> wrote @ Wed, 6 Feb 2013 10:52:54 +0100:

> > diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> > index f0ac818..bb5d36a 100644
> > --- a/include/linux/clk-provider.h
> > +++ b/include/linux/clk-provider.h
> > @@ -346,6 +346,8 @@ struct clk_composite {
> >          const struct clk_ops    *mux_ops;
> >          const struct clk_ops    *div_ops;
> >          const struct clk_ops    *gate_ops;
> > +
> > +       const struct clk_ops    ops;
> >   };
> >   
> >   struct clk *clk_register_composite(struct device *dev, const char *name,
> 
> This will work, but there is no harm in allocating dynamically. What is 
> preferred?

If we've already know that this "ops" is necessary per "struct
clk_composite" in advance, there's no point to allocate
"clk_composite" and "ops" separately.
