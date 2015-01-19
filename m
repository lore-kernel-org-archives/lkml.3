Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbbASQ2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:28:21 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51513 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbbASQ2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:28:18 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: James Liao <jamesjj.liao@mediatek.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1420685701.27952.44.camel@mtksdaap41>
Cc: "Rob Herring" <robh+dt@kernel.org>,
        "srv_heupstream" <srv_heupstream@mediatek.com>,
        "Sascha Hauer" <kernel@pengutronix.de>,
        "huang eddie" <eddie.huang@mediatek.com>,
        "HenryC Chen" <henryc.chen@mediatek.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        "Vladimir Murzin" <vladimir.murzin@arm.com>,
        "Ashwin Chaugule" <ashwin.chaugule@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1420601123-25859-1-git-send-email-jamesjj.liao@mediatek.com>
 <1420601123-25859-3-git-send-email-jamesjj.liao@mediatek.com>
 <CABuKBeLQkTBYWkBWAYXjYudMAza+1zueRSqGFPd+480p1rYNwg@mail.gmail.com>
 <1420685701.27952.44.camel@mtksdaap41>
Message-ID: <20150119162808.22722.33140@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v3 2/4] clk: mediatek: Add initial common clock support for
 Mediatek SoCs.
Date: Mon, 19 Jan 2015 08:28:08 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Liao (2015-01-07 18:55:01)
> Hi Matthias,
> 
> On Wed, 2015-01-07 at 18:22 +0100, Matthias Brugger wrote:
> > 2015-01-07 4:25 GMT+01:00 James Liao <jamesjj.liao@mediatek.com>:
> > > +
> > > +static void cg_set_mask(struct mtk_clk_gate *cg, u32 mask)
> > 
> > Please add mtk_ prefix to all functions generic for the mediatek SoCs.
> 
> OK.
> 
> > 
> > > +       if (cg->flags & CLK_GATE_NO_SETCLR_REG) {
> > 
> > Is the CLK_GATE_NO_SETCLR_REG ever used?
> > As far as I can see, in this patch set it is not.
> 
> No, this flag is not used in this patch. I'll remove it or add clocks
> which use this flag in next patch.
> 
> > > +
> > > +       if (cg->flags & CLK_GATE_INVERSE)
> > > +               cg_set_mask(cg, mask);
> > > +       else
> > > +               cg_clr_mask(cg, mask);
> > > +
> > > +       mtk_clk_unlock(flags);
> > > +
> > > +       return 0;
> > > +}
> > 
> > Actually we should use CLK_GATE_SET_TO_DISABLE instead of inventing a
> > new bit, right?
> 
> CLK_GATE_SET_TO_DISABLE is used by struct clk_gate, which is different
> from struct mtk_clk_gate. Should we use the same constant in these 2
> different implementation? If yes, how do we avoid bit conflict between
> clk_gate and mtk_clk_gate if we both add more flags in the future?

I think that CLK_GATE_INVERSE is fine. This clock gate implementation is
sufficiently different from the simple drivers/clk/clk-gate.c
implementation (e.g. separate registers for setting bits, clearing bits
and getting status).

Regards,
Mike

> 
> 
> > > +       pr_debug("%s(): %d, %s, bit[%d]\n",
> > > +               __func__, r, __clk_get_name(hw->clk), (int)cg->bit);
> > 
> > Same here. Please review all debug messages.
> 
> OK, I'll remove them in next patch.
> 
> 
> > > +
> > > +#define CLK_DEBUG              0
> > > +#define DUMMY_REG_TEST         0
> > 
> > This defines are not used, delete them.
> 
> OK.
> 
> > > +
> > > +extern spinlock_t *get_mtk_clk_lock(void);
> > > +
> > > +#define mtk_clk_lock(flags)    spin_lock_irqsave(get_mtk_clk_lock(), flags)
> > > +#define mtk_clk_unlock(flags)  \
> > > +       spin_unlock_irqrestore(get_mtk_clk_lock(), flags)
> > 
> > Please use the spinlock directly without this akward defines.
> 
> Do you mean we should export clk_ops_lock (from clk-mtk.c) directly
> instead of get_mtk_clk_lock()? Or simply remove mtk_clk_lock/unlock()?
> 
> 
> Best regards,
> 
> James
> 
> 
> 
