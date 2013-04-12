Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab3DLODE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 10:03:04 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:50958 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab3DLODD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 10:03:03 -0400
MIME-Version: 1.0
In-Reply-To: <1365532783-27425-5-git-send-email-lee.jones@linaro.org>
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org> <1365532783-27425-5-git-send-email-lee.jones@linaro.org>
From: Rabin Vincent <rabin@rab.in>
Date: Fri, 12 Apr 2013 16:02:21 +0200
X-Google-Sender-Auth: Njy3ZitQ-NgVT9j1xoBdKBIjOos
Message-ID: <CAH+eYFCuYg5cyqs8-jWq+9-qjG=Q1s5q+fz+5pu-BxHXtFe2Hw@mail.gmail.com>
Subject: Re: [PATCH 5/8] dmaengine: ste_dma40: Ensure src and dst registers
 are configured correctly
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/9 Lee Jones <lee.jones@linaro.org>:
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index 9e423ad..49d8c9d 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -2810,9 +2810,9 @@ static int d40_set_runtime_config(struct dma_chan *chan,
>         /* Fill in register values */
>         if (chan_is_logical(d40c))
>                 d40_log_cfg(cfg, &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
> -       else
> -               d40_phy_cfg(cfg, &d40c->src_def_cfg,
> -                           &d40c->dst_def_cfg, false);
> +
> +       d40_phy_cfg(cfg, &d40c->src_def_cfg, &d40c->dst_def_cfg,
> +                   chan_is_logical(d40c));
>
>         /* These settings will take precedence later */
>         d40c->runtime_addr = config_addr;

There is no need to call this function there.  For a logical channel,
the underlying physical channel's SSCFG/SDCFG should only be written
once in the beginning (via d40_config_write()) so there is no need to
change this src_def_cfg and dst_def_cfg again without using them.  For a
logical channel, d40_phy_cfg() does nothing else which is
runtime_config()able.
