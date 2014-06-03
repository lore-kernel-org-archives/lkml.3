Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaFCHKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:10:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43857 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753302AbaFCHKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:10:21 -0400
Date: Tue, 3 Jun 2014 09:10:17 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] ARM: berlin: add SMP support
Message-ID: <20140603071017.GA15966@kwain>
References: <1401700866-24804-1-git-send-email-antoine.tenart@free-electrons.com>
 <1401700866-24804-2-git-send-email-antoine.tenart@free-electrons.com>
 <20140603143113.0b2aeb74@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140603143113.0b2aeb74@xhacker>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jisheng,

On Tue, Jun 03, 2014 at 02:31:13PM +0800, Jisheng Zhang wrote:
> On Mon, 2 Jun 2014 02:21:02 -0700
> Antoine Ténart <antoine.tenart@free-electrons.com> wrote:
> > +
> > +extern void berlin_secondary_startup(void);
> > +extern u32 boot_inst;
> > +
> > +static void __iomem *cpu_ctrl;
> > +
> > +static inline void berlin_reset_cpu(unsigned int cpu)
> > +{
> > +	u32 val;
> > +
> > +	val = readl(cpu_ctrl + CPU_RESET);
> > +	val |= BIT(cpu_logical_map(cpu));
> > +	writel(val, cpu_ctrl + CPU_RESET);
> 
> "writel(BIT(cpu_logical_map(cpu)), cpu_ctrl + CPU_RESET)" is enough.
> we don't need to read and modify, because we writing 0 has no any effect.

The reset bit is automatically cleared but I dumped the register value
and it wasn't 0x0, that's why I preferred to read first and only set the
reset bit.

> > +
> > +	/*
> > +	 * Write the first instruction the CPU will execute after being
> > reseted
> > +	 * in the reset exception register.
> > +	 */
> > +	writel(boot_inst, vectors_base + RESET_VECT);
> 
> Is it better to let bootloader/firmware handle this writing. Then, we can
> also remove the tricky boot_inst in headsmp.S.

We thought about it, and since it can be difficult to update the
bootloader for some boards, like BG2 based ones, we preferred to include
this here.

Thanks!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
