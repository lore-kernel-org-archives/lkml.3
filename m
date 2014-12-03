Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaLCIkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 03:40:23 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:53542 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751463AbaLCIkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 03:40:21 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v2 2/8] mfd: MT6397: Add support for PMIC MT6397 MFD
From: Flora Fu <flora.fu@mediatek.com>
To: Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, Sascha Hauer <kernel@pengutronix.de>,
        <srv_heupstream@mediatek.com>, Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Flora Fu <flora.fu@mediatek.com>
In-Reply-To: <20141201114717.GD15845@x1>
References: <1417146874-5232-1-git-send-email-flora.fu@mediatek.com>
	 <1417146874-5232-3-git-send-email-flora.fu@mediatek.com>
	 <20141201114717.GD15845@x1>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 3 Dec 2014 16:40:18 +0800
Message-ID: <1417596018.24267.62.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-01 at 11:47 +0000, Lee Jones wrote:
> On Fri, 28 Nov 2014, Flora Fu wrote:

> 
> > +	if (!mt6397)
> > +		return -ENOMEM;
> > +
> > +	mt6397->dev = &pdev->dev;
> 
> Is this used else where?  If not, I think you can remove it.

No one is used it in this patch sets but it will be used for irq
functions to get irq id or print logs for error case in the future.
Can I keep it in the patch?

> 
> > +	mt6397->regmap = wrp->regmap;
> > +	platform_set_drvdata(pdev, mt6397);
> 
> Then you can platform_set_drvdata(pdev, regmap);
> 
> Although I don't see this being used either.  Is it used in the child
> devices?
> 
Yes, it is used to provide regmap handle for its child device. In the
patch set, regulator uses it.

Thanks,
Flora

