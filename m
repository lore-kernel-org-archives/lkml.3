Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab3GEUNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 16:13:37 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:36238 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752162Ab3GEUNg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 16:13:36 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dIc89bh1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Fri, 5 Jul 2013 13:12:37 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Baruch Siach <baruch@tkos.co.il>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH] clocksource/cadence_ttc: Reuse clocksource as sched_clock
References: <1372888216-10726-1-git-send-email-soren.brinkmann@xilinx.com>
 <20130704033026.GX4288@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130704033026.GX4288@tarshish>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <0030b826-0eb1-4bb8-a0de-1d8dc68bd81a@TX2EHSMHS017.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 06:30:26AM +0300, Baruch Siach wrote:
> Hi Soren,
> 
> On Wed, Jul 03, 2013 at 02:50:16PM -0700, Soren Brinkmann wrote:
> > Reuse the TTC clocksource timer as sched clock, too. Since only a single
> > sched clock is supported in Linux, this feature optional and can be
> > selected through Kconfig.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> 
> [...]
> 
> > diff --git a/drivers/clocksource/cadence_ttc_timer.c 
> > b/drivers/clocksource/cadence_ttc_timer.c
> > index 4cbe28c..ef0f52b 100644
> > --- a/drivers/clocksource/cadence_ttc_timer.c
> > +++ b/drivers/clocksource/cadence_ttc_timer.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/of_irq.h>
> >  #include <linux/slab.h>
> >  #include <linux/clk-provider.h>
> > +#include <asm/sched_clock.h>
> 
> This has changed to linux/sched_clock.h in the tip tree. See 
> https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?h=timers/core&id=38ff87f77af0b5a93fc8581cff1d6e5692ab8970.
Is that change going into Linus' tree during the 3.11 merge window? The
tip tree is missing some changes to the TTC which went in through the
armsoc tree.

	Sören


