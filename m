Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbaDKJYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:24:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44622 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756580AbaDKJWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:22:01 -0400
Date: Fri, 11 Apr 2014 11:21:57 +0200
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
Message-ID: <20140411092157.GD20147@kwain>
References: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com>
 <1397135274-10764-3-git-send-email-antoine.tenart@free-electrons.com>
 <20140411144431.04fb148d@xhacker>
 <20140411081839.GB20147@kwain>
 <20140411162716.74e739e1@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140411162716.74e739e1@xhacker>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jisheng,

On Fri, Apr 11, 2014 at 04:27:16PM +0800, Jisheng Zhang wrote:
> Hi Antoine,
> 
> On Fri, 11 Apr 2014 01:18:39 -0700
> Antoine Ténart <antoine.tenart@free-electrons.com> wrote:
> 
> > Hi Jisheng,
> > 
> > On Fri, Apr 11, 2014 at 02:44:31PM +0800, Jisheng Zhang wrote:
> > > On Thu, 10 Apr 2014 06:07:51 -0700
> > > Antoine Ténart <antoine.tenart@free-electrons.com> wrote:
> > > 
> > > ...
> > > > +static int berlin_pinmux_enable(struct pinctrl_dev *pctrl_dev,
> > > > +                               unsigned function,
> > > > +                               unsigned group)
> > > > +{
> > > > +       struct berlin_pinctrl *pctrl =
> > > > pinctrl_dev_get_drvdata(pctrl_dev);
> > > > +       struct berlin_pinctrl_group *group_desc = pctrl->groups + group;
> > > > +       struct berlin_pinctrl_function *function_desc =
> > > > +               pctrl->functions + function;
> > > > +       unsigned long flags;
> > > > +       u32 regval;
> > > > +
> > > > +       spin_lock_irqsave(&pctrl->lock, flags);
> > > > +
> > > > +       regval = readl(group_desc->reg);
> > > > +       regval &= group_desc->mask;
> > > > +       regval |= function_desc->muxval << group_desc->lsb;
> > > > +       writel(regval, group_desc->reg);
> > > 
> > > Could we use relaxed version instead?
> > 
> > We could, but this is not a performance issue here at all, so I guess we can
> > keep writel().
> 
> Yes it's not a performance issue here but an issue for the system which is doing
> PL310 L2 cache maintenance. If pinmux operation hold the l2x0_lock due to writel()
> the important video/audio process which is cleaning PL310 cache must wait, thus
> cause jitter. So I'd like relaxed version if we can. Then I don't need to add this
> patch to mainline kernel when we upgrade internal tree.

I'm not sure I got that. As I understand it, you will need to play video/audio
*while* configuring the pinmux. But the pinmuxing configuration is done at boot
time, and I don't think a video/audio is being played then. So I'm not certain a
jitter will appear. What do you think ?

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
