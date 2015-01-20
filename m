Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbbATMjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:39:07 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:41187 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbbATMjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:39:05 -0500
MIME-Version: 1.0
In-Reply-To: <1420685701.27952.44.camel@mtksdaap41>
References: <1420601123-25859-1-git-send-email-jamesjj.liao@mediatek.com>
	<1420601123-25859-3-git-send-email-jamesjj.liao@mediatek.com>
	<CABuKBeLQkTBYWkBWAYXjYudMAza+1zueRSqGFPd+480p1rYNwg@mail.gmail.com>
	<1420685701.27952.44.camel@mtksdaap41>
Date: Tue, 20 Jan 2015 13:39:03 +0100
Message-ID: <CABuKBeLFvP4ChnzzUJwoLtCHtH6PejENJueBd7D+xMJhBMDBkg@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] clk: mediatek: Add initial common clock support
 for Mediatek SoCs.
From: Matthias Brugger <matthias.bgg@gmail.com>
To: James Liao <jamesjj.liao@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        huang eddie <eddie.huang@mediatek.com>,
        HenryC Chen <henryc.chen@mediatek.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-08 3:55 GMT+01:00 James Liao <jamesjj.liao@mediatek.com>:
> Hi Matthias,
>
> On Wed, 2015-01-07 at 18:22 +0100, Matthias Brugger wrote:
>> 2015-01-07 4:25 GMT+01:00 James Liao <jamesjj.liao@mediatek.com>:
[...]
>> > +
>> > +extern spinlock_t *get_mtk_clk_lock(void);
>> > +
>> > +#define mtk_clk_lock(flags)    spin_lock_irqsave(get_mtk_clk_lock(), flags)
>> > +#define mtk_clk_unlock(flags)  \
>> > +       spin_unlock_irqrestore(get_mtk_clk_lock(), flags)
>>
>> Please use the spinlock directly without this akward defines.
>
> Do you mean we should export clk_ops_lock (from clk-mtk.c) directly
> instead of get_mtk_clk_lock()? Or simply remove mtk_clk_lock/unlock()?
>

I think you should use spin_lock_irqsave(&clk_ops_lock, flags) instead
of mtk_clk_lock.
In any case I think you should define a spinlock in clk-mt8135.c and
pass a reference of it in the init functions.
See drivers/clk/berlin as a good example.

Thanks,
Matthias

-- 
motzblog.wordpress.com
