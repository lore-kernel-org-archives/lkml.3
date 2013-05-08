Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab3EHPZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:25:05 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:54454 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab3EHPZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:25:04 -0400
Date: Wed, 8 May 2013 16:24:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 21/63] dmaengine: ste_dma40: Don't configure runtime
 configurable setup during allocate
Message-ID: <20130508152458.GM3459@gmail.com>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
 <1367591569-32197-22-git-send-email-lee.jones@linaro.org>
 <CACRpkdbZmzJhZuST+T+qomK_q3q9wt34CGS6sqk0JkZV-Q6O7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbZmzJhZuST+T+qomK_q3q9wt34CGS6sqk0JkZV-Q6O7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 May 2013, Linus Walleij wrote:

> On Fri, May 3, 2013 at 4:32 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Using the dmaengine API, allocating and configuring a channel are two
> > separate actions. Here we're removing logical channel configuration from
> > the channel allocating routines.
> >
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > Cc: Dan Williams <djbw@fb.com>
> > Cc: Per Forlin <per.forlin@stericsson.com>
> > Cc: Rabin Vincent <rabin@rab.in>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> (...)
> 
> > @@ -2024,6 +2024,9 @@ static int d40_config_memcpy(struct d40_chan *d40c)
> >                 d40c->dma_cfg = dma40_memcpy_conf_log;
> >                 d40c->dma_cfg.dev_type = dma40_memcpy_channels[d40c->chan.chan_id];
> >
> > +               d40_log_cfg(&d40c->dma_cfg,
> > +                           &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
> > +
> 
> So it only gets configured for memcpy now?
> 
> What happens if you use a logical channel for a device transfer?
> 
> Where will that be configured?

In d40_set_runtime_config()

> /* Fill in register values */
> if (chan_is_logical(d40c))
> 	d40_log_cfg(cfg, &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
> else
> 	d40_phy_cfg(cfg, &d40c->src_def_cfg, &d40c->dst_def_cfg);

> Have you tested this combo?

Yes. All ux500 based DMA use logical channels.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
