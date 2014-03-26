Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbaCZDnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 23:43:04 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:45442 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaCZDnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 23:43:02 -0400
X-Auth-Info: L0Xs1AfBn2p0m3nOsKDnA/9IuPu6fdKRgSDnxgjgwXc=
From: Marek Vasut <marex@denx.de>
To: Yao Yuan <yao.yuan@freescale.com>
Subject: Re: [PATCH v3 1/2] i2c: add DMA support for freescale i2c driver
Date: Wed, 26 Mar 2014 04:42:42 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
References: <1394675277-24913-1-git-send-email-yao.yuan@freescale.com> <201403230449.51515.marex@denx.de> <1e17ce716618472f9a0146c48f20b976@BL2PR03MB338.namprd03.prod.outlook.com>
In-Reply-To: <1e17ce716618472f9a0146c48f20b976@BL2PR03MB338.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201403260442.42970.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 26, 2014 at 04:08:27 AM, Yao Yuan wrote:

[...]

> > > +		i2c_imx->use_dma = false;
> > > +	} else if (i2c_imx_dma_request(i2c_imx, (dma_addr_t)phy_addr)) {
> > > +		dev_info(&pdev->dev,
> > > +				"can't request dma chan, faild use dma.\n");
> > > +		i2c_imx->use_dma = false;
> > > +	} else {
> > > +		i2c_imx->use_dma = true;
> > > +	}
> > 
> > Can you not just check if i2c_imx->dma is valid pointer or NULL pointer ?
> > Then you won't need a separate variable, for this purpose ... right ?
> 
> Sorry and I think what I know is just to check whether it is NULL.
> Then for the second question, maybe there are some other ways, But I think
> it is more tidy and easier understanding for using a separate variable,
> for this purpose.

You are just wasting space and duplicating data, unless I am wrong.

Best regards,
Marek Vasut
