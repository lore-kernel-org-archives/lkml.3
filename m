Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab3EQMUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 08:20:51 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:33539 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab3EQMUt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 08:20:49 -0400
MIME-Version: 1.0
In-Reply-To: <201305152231.52423.heiko@sntech.de>
References: <201305111330.05046.heiko@sntech.de>
	<201305111331.25405.heiko@sntech.de>
	<CACRpkdaT195McX9NeccJYpmWbuYK-AZUTHr9AXKHnJdkf+Qzuw@mail.gmail.com>
	<201305152231.52423.heiko@sntech.de>
Date: Fri, 17 May 2013 14:20:49 +0200
Message-ID: <CACRpkdaGBjUfhfT2zCEeNmMh3KhouOMjKSB7H6_cu_uDM6cm=w@mail.gmail.com>
Subject: Re: [RFC 2/4] dma: add dmaengine driver for Samsung s3c24xx SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 10:31 PM, Heiko Stübner <heiko@sntech.de> wrote:

> If I understand the writel semantics and the thread from you from 2011 [0]
> correctly, only the writel to DMASKTRIG mustn't be relaxed to make sure the
> settings registers are written to before, so like:
>
>        writel_relaxed(txd->src_addr, phy->base + DISRC);
>        writel_relaxed(txd->disrcc, phy->base + DISRCC);
>        writel_relaxed(txd->dst_addr, phy->base + DIDST);
>        writel_relaxed(txd->didstc, phy->base + DIDSTC);
>        writel_relaxed(dcon, phy->base + DCON);
>
>        val = readl_relaxed(phy->base + DMASKTRIG);
>        val &= ~DMASKTRIG_STOP;
>        val |= DMASKTRIG_ON;
>        writel(val, phy->base + DMASKTRIG);

Yep. That will drain write buffers etc and make sure all outstanding writes hit
the hardware.

Yours,
Linus Walleij
