Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809Ab3GEQNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:13:33 -0400
Received: from mail-db9lp0248.outbound.messaging.microsoft.com ([213.199.154.248]:51297
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757517Ab3GEQNJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:13:09 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh154dI1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Fri, 5 Jul 2013 09:12:51 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: John Stultz <john.stultz@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH] clocksource/cadence_ttc: Reuse clocksource as sched_clock
References: <1372888216-10726-1-git-send-email-soren.brinkmann@xilinx.com>
 <alpine.DEB.2.02.1307050819000.11637@ionos.tec.linutronix.de>
 <fbeb6f36-f07a-4518-b6f2-0b8e36028fe9@CH1EHSMHS012.ehs.local>
 <alpine.DEB.2.02.1307051802560.32106@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307051802560.32106@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <e55e70b7-7e63-4718-ad48-f5d4479b5326@DB9EHSMHS006.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 06:05:14PM +0200, Thomas Gleixner wrote:
> On Fri, 5 Jul 2013, Sören Brinkmann wrote:
> > On Fri, Jul 05, 2013 at 08:30:47AM +0200, Thomas Gleixner wrote:
> > > On Wed, 3 Jul 2013, Soren Brinkmann wrote:
> > > 
> > > > Reuse the TTC clocksource timer as sched clock, too. Since only a single
> > > > sched clock is supported in Linux, this feature optional and can be
> > > > selected through Kconfig.
> > > 
> > > This changelog doesn't make sense.
> > > 
> > > There can be only one active sched_clock, but that does no mean, that
> > > you cannot have different implementations compiled in.
> > > 
> > > So if you disable this config which sched_clock is your kernel using?
> > Jiffies
> > 
> > > And if you enable it, how is guaranteed that you end up with the ttc
> > > sched_clock as the active one? Just due to initcall ordering?
> > I assumed so. Is there a different mechanism?
> 
> jiffies is the default one. If you setup an explicit sched clock then
> this is used. initcall ordering only matters if you have two possible
> sched clocks which might replace jiffies. The one which gets
> registered last wins.
> 
> So the question is, why you want to disable your sched clock at
> compile time.
The timer drivers I have seen unconditionally register themselves as
sched_clock. There does not seem to be a runtime mechanism to choose the
best one - I might miss it though.
I was thinking about this due to the arm_global_timer driver which has
been dicussed on lkml recently, which seemed to do it this way too. And since
that timer would be an alternative sched_clock for Zynq too, I thought I
follow the same approach for the TTC.

	Sören


