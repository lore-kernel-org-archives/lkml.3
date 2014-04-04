Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaDDMnC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:43:02 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:51018 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaDDMm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:42:58 -0400
X-Auth-Info: ziSxuI7WXGZJMSQdFtxwt6Eoqdf7RCLy9f04x0A2lFI=
From: Marek Vasut <marex@denx.de>
To: sourav <sourav.poddar@ti.com>
Subject: Re: [PATCH v4 1/2] i2c: add DMA support for freescale i2c driver
Date: Fri, 4 Apr 2014 13:49:07 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: Yuan Yao <yao.yuan@freescale.com>, wsa@the-dreams.de, mark.rutland@arm.com,
        shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
References: <1396579272-19542-1-git-send-email-yao.yuan@freescale.com> <1396579272-19542-2-git-send-email-yao.yuan@freescale.com> <533E8033.70904@ti.com>
In-Reply-To: <533E8033.70904@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201404041349.07721.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 04, 2014 at 11:49:39 AM, sourav wrote:

[...]

> > +/* Functions for DMA support */
> > +static int i2c_imx_dma_request(struct imx_i2c_struct *i2c_imx,
> > +						dma_addr_t phy_addr)
> > +{
> > +	struct imx_i2c_dma *dma;
> > +	struct dma_slave_config dma_sconfig;
> > +	struct device *dev =&i2c_imx->adapter.dev;
> > +	int ret;
> > +
> > +	dma = devm_kzalloc(dev, sizeof(struct imx_i2c_dma), GFP_KERNEL);
> > +	if (!dma) {
> > +		dev_info(dev, "can't allocate DMA struct\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	dma->chan_tx = dma_request_slave_channel(dev, "tx");
> > +	return 0;
> 
> ?? Looks to be some leftover?

Nice find.

btw. you might want to trim the email only to the relevant parts when replying 
so it's easier to find your commments in the entire body of text.
 
> > +	if (!dma->chan_tx) {
> > +		dev_info(dev, "DMA tx channel request failed\n");
> > +		ret = -ENODEV;
> > +		goto fail_al;
> > +	}

[...]

Best regards,
Marek Vasut
