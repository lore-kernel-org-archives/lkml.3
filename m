Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab3DYJNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:13:18 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:55049 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab3DYJNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:13:17 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-14-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-14-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 11:13:16 +0200
Message-ID: <CACRpkdYq9QLRaaysc=izGgi53ogf1oRHuCwWKW+rQBbE_UtfnA@mail.gmail.com>
Subject: Re: [PATCH 13/32] dmaengine: ste_dma40: Calculate number of logical
 channels from physical ones
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This change will cost ~25KB of memory, but it's worth the trade-off,
> as it removes a great deal of overhead. It means that instead of only
> allocating memory for the logical channels in use, it does so for all
> available ones, which is 32 per physical channel. However, this now
> means we can remove some platform data and we don't have to worry
> about adding vendor specific variables to Device Tree.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

(...)
>  static struct stedma40_platform_data dma40_plat_data = {
> -       .dev_len = DB8500_DMA_NR_DEV,

So that was set to 64 in the platform...

> -       /* Count the number of logical channels in use */
> -       for (i = 0; i < plat_data->dev_len; i++)
> -               if (plat_data->dev_rx[i] != 0)
> -                       num_log_chans++;
> -
> -       for (i = 0; i < plat_data->dev_len; i++)
> -               if (plat_data->dev_tx[i] != 0)
> -                       num_log_chans++;

And I guess this code snippet made it go down to <= 32 all the time,
correct?

Just want to understand it before I ACK. (The idea is sound.)

I notice there is no check whatsoever of the bounds of
plat_data->dev_[rx|tx]  but that is a different problem I guess...

Yours,
Linus Walleij
