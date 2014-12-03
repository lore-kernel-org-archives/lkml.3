Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaLCJ02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:26:28 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:37306 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaLCJ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:26:26 -0500
Date: Wed, 3 Dec 2014 09:26:19 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Flora Fu <flora.fu@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        srv_heupstream@mediatek.com, Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Subject: Re: [PATCH v2 2/8] mfd: MT6397: Add support for PMIC MT6397 MFD
Message-ID: <20141203092619.GA327@x1>
References: <1417146874-5232-1-git-send-email-flora.fu@mediatek.com>
 <1417146874-5232-3-git-send-email-flora.fu@mediatek.com>
 <20141201114717.GD15845@x1>
 <1417596018.24267.62.camel@mtksdaap41>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417596018.24267.62.camel@mtksdaap41>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2014, Flora Fu wrote:

> On Mon, 2014-12-01 at 11:47 +0000, Lee Jones wrote:
> > On Fri, 28 Nov 2014, Flora Fu wrote:
> 
> > 
> > > +	if (!mt6397)
> > > +		return -ENOMEM;
> > > +
> > > +	mt6397->dev = &pdev->dev;
> > 
> > Is this used else where?  If not, I think you can remove it.
> 
> No one is used it in this patch sets but it will be used for irq
> functions to get irq id or print logs for error case in the future.
> Can I keep it in the patch?

It's not uncommon for devices to do this and if you're sure it's going
to be used in the future you may as well keep it in.

> > > +	mt6397->regmap = wrp->regmap;
> > > +	platform_set_drvdata(pdev, mt6397);
> > 
> > Then you can platform_set_drvdata(pdev, regmap);
> > 
> > Although I don't see this being used either.  Is it used in the child
> > devices?
> > 
> Yes, it is used to provide regmap handle for its child device. In the
> patch set, regulator uses it.

Okay.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
