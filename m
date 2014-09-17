Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbaIQTOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 15:14:41 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:53320 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbaIQTOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:14:39 -0400
X-Auth-Info: /DTum/wXE7T1fXVItjBN0hNLOnPt7FlcjpqiPI4k0dE=
From: Marek Vasut <marex@denx.de>
To: Yao Yuan <yao.yuan@freescale.com>
Subject: Re: [PATCH v7 1/2] i2c: imx: add DMA support for freescale i2c driver
Date: Wed, 17 Sep 2014 21:14:36 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "LW@karo-electronics.de" <LW@karo-electronics.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "fugang.duan@freescale.com" <fugang.duan@freescale.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
References: <1407923215-3749-1-git-send-email-yao.yuan@freescale.com> <201409162017.06439.marex@denx.de> <1410965416759.91038@freescale.com>
In-Reply-To: <1410965416759.91038@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201409172114.36617.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 17, 2014 at 04:50:34 PM, Yao Yuan wrote:
[...]
> > > > Would that mean that the "crashed" DMA would be running until the
> > > > next transmission is scheduled ?
> > > 
> > > [Yuan Yao] No, In fact any DMA timeout will result the failure of I2C
> > > transmission and then it will turn to report the exception and wait
> > > for next transmission.
> > 
> > Can you tell when the next transmission will happen? What if I issue a
> > single transmission and that one fails ? Will the DMA run until who knows
> > when ?
> 
> [Yuan Yao]
> Sorry for my unclear description. In fact, During the DMA transmission  if
> an error happened or time out, DMA will stop at once and be disabled.
> I just continue to route the TX and RX request to signal the DMA
> controller. Because the DMA is disabled, it will ignore those signals.
> 
> In a word, I just want to block the I2C TX, RX and interrupt signal when
> DMA mode failed until the next I2C transmission start.

So the I2C block is in error state until you clean it up upon next transmission?

> In fact, the bit "I2CR_DMAEN" is a switch which decide whether I2C route
> the TX, RX and interrupt signal to DMA controller.
> 
> > > The only thing I worried about is I2C may still receive some feedbacks
> > > after DMA timeout. In this case the feedbacks may lead to abnormal
> > > state in PIO mode.But it will be ignored in DMA model.
> > > That's why I tend to delay force-disable DMA until the next
> > > transmission begin. Could you please give me some suggestion?
> > 
> > No, this design just seems flawed to me. You should stop the DMA
> > immediatelly if there is an error to avoid wasting resources and prevent
> > possible other adverse effects.
> 
> [Yuan Yao]
> Yes, I have stopped the DMA immediately. However I keep the I2C DMA
> single route.
> 
> I don't have the exact evidence to prove that my design is acceptable.
> So if you are sure it's flawed, I will change it in the next version(V8).

I'm just trying to understand it.

Best regards,
Marek Vasut
