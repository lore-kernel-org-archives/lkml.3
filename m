Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763567Ab3ECUlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:41:55 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:58499 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3ECUly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:41:54 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-22-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-22-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 22:41:51 +0200
Message-ID: <CACRpkdbZmzJhZuST+T+qomK_q3q9wt34CGS6sqk0JkZV-Q6O7A@mail.gmail.com>
Subject: Re: [PATCH 21/63] dmaengine: ste_dma40: Don't configure runtime
 configurable setup during allocate
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 4:32 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Using the dmaengine API, allocating and configuring a channel are two
> separate actions. Here we're removing logical channel configuration from
> the channel allocating routines.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
(...)

> @@ -2024,6 +2024,9 @@ static int d40_config_memcpy(struct d40_chan *d40c)
>                 d40c->dma_cfg = dma40_memcpy_conf_log;
>                 d40c->dma_cfg.dev_type = dma40_memcpy_channels[d40c->chan.chan_id];
>
> +               d40_log_cfg(&d40c->dma_cfg,
> +                           &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
> +

So it only gets configured for memcpy now?

What happens if you use a logical channel for a device transfer?

Where will that be configured?

Have you tested this combo?

Yours,
Linus Walleij
