Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbaDKISq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:18:46 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44169 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750805AbaDKISn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:18:43 -0400
Date: Fri, 11 Apr 2014 10:18:39 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 2/5] pinctrl: berlin: add a pinctrl driver for
 Marvell Berlin SoCs
Message-ID: <20140411081839.GB20147@kwain>
References: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com>
 <1397135274-10764-3-git-send-email-antoine.tenart@free-electrons.com>
 <20140411144431.04fb148d@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140411144431.04fb148d@xhacker>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jisheng,

On Fri, Apr 11, 2014 at 02:44:31PM +0800, Jisheng Zhang wrote:
> On Thu, 10 Apr 2014 06:07:51 -0700
> Antoine Ténart <antoine.tenart@free-electrons.com> wrote:
> 
> ...
> > +static int berlin_pinmux_enable(struct pinctrl_dev *pctrl_dev,
> > +                               unsigned function,
> > +                               unsigned group)
> > +{
> > +       struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
> > +       struct berlin_pinctrl_group *group_desc = pctrl->groups + group;
> > +       struct berlin_pinctrl_function *function_desc =
> > +               pctrl->functions + function;
> > +       unsigned long flags;
> > +       u32 regval;
> > +
> > +       spin_lock_irqsave(&pctrl->lock, flags);
> > +
> > +       regval = readl(group_desc->reg);
> > +       regval &= group_desc->mask;
> > +       regval |= function_desc->muxval << group_desc->lsb;
> > +       writel(regval, group_desc->reg);
> 
> Could we use relaxed version instead?

We could, but this is not a performance issue here at all, so I guess we can
keep writel().

Thanks for the feedback !

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
