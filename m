Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbaCCLSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:18:43 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:58040 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbaCCLSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:18:41 -0500
X-Auth-Info: gpbdZ0vqnZKqhRF24GBCBKWVkJWvV2S0ImPhWpx8H1Q=
From: Marek Vasut <marex@denx.de>
To: Yao Yuan <yao.yuan@freescale.com>
Subject: Re: [PATCH 1/3] i2c: add DMA support for freescale i2c driver
Date: Mon, 3 Mar 2014 12:14:12 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
References: <1393481115-22136-1-git-send-email-yao.yuan@freescale.com> <201402272139.36076.marex@denx.de> <3bbad0af0bc74f04bc386b141dadedb3@BL2PR03MB338.namprd03.prod.outlook.com>
In-Reply-To: <3bbad0af0bc74f04bc386b141dadedb3@BL2PR03MB338.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201403031214.12605.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 03, 2014 at 11:23:33 AM, Yao Yuan wrote:
> Hi, Marek
> 
> Marek Vasut wrote:
> > On Thursday, February 27, 2014 at 07:05:14 AM, Yuan Yao wrote:
> > 
> > [...]
> > 
> > > +static void i2c_imx_dma_free(struct imx_i2c_struct *i2c_imx) {
> > > +	struct imx_i2c_dma *dma = i2c_imx->dma;
> > > +	struct dma_chan *dma_chan;
> > > +
> > > +	dma_chan = dma->chan_tx;
> > > +	dma->chan_tx = NULL;
> > > +	dma->buf_tx = 0;
> > > +	dma->len_tx = 0;
> > > +	dma_release_channel(dma_chan);
> > > +
> > > +	dma_chan = dma->chan_rx;
> > > +	dma->chan_tx = NULL;
> > > +	dma->buf_rx = 0;
> > > +	dma->len_rx = 0;
> > > +	dma_release_channel(dma_chan);
> > 
> > You must make _DEAD_ _SURE_ this function is not ever called while the
> > DMA is still active. In your case, I have a feeling that's not handled.
> 
> Thanks for your attention.
> This few days I look up the code for the realization of
> dma_release_channel(). I found that it will disable the dma request first.
> So it's may safe. And drivers hadn't check whether dma is still active
> before dma_release_channel() as a usually usage. Because it will be
> disabled automatic.
> 
> The only problem is that, it will be forced to cancel the transfer which
> was not yet completed. Looking forward to hearing from you.

OK

Best regards,
Marek Vasut
