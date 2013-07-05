Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab3GEQFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:05:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:45830 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360Ab3GEQFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:05:12 -0400
Date: Fri, 5 Jul 2013 18:05:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH] clocksource/cadence_ttc: Reuse clocksource as
 sched_clock
In-Reply-To: <fbeb6f36-f07a-4518-b6f2-0b8e36028fe9@CH1EHSMHS012.ehs.local>
Message-ID: <alpine.DEB.2.02.1307051802560.32106@ionos.tec.linutronix.de>
References: <1372888216-10726-1-git-send-email-soren.brinkmann@xilinx.com> <alpine.DEB.2.02.1307050819000.11637@ionos.tec.linutronix.de> <fbeb6f36-f07a-4518-b6f2-0b8e36028fe9@CH1EHSMHS012.ehs.local>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-193646010-1373040314=:32106"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-193646010-1373040314=:32106
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 5 Jul 2013, Sören Brinkmann wrote:
> On Fri, Jul 05, 2013 at 08:30:47AM +0200, Thomas Gleixner wrote:
> > On Wed, 3 Jul 2013, Soren Brinkmann wrote:
> > 
> > > Reuse the TTC clocksource timer as sched clock, too. Since only a single
> > > sched clock is supported in Linux, this feature optional and can be
> > > selected through Kconfig.
> > 
> > This changelog doesn't make sense.
> > 
> > There can be only one active sched_clock, but that does no mean, that
> > you cannot have different implementations compiled in.
> > 
> > So if you disable this config which sched_clock is your kernel using?
> Jiffies
> 
> > And if you enable it, how is guaranteed that you end up with the ttc
> > sched_clock as the active one? Just due to initcall ordering?
> I assumed so. Is there a different mechanism?

jiffies is the default one. If you setup an explicit sched clock then
this is used. initcall ordering only matters if you have two possible
sched clocks which might replace jiffies. The one which gets
registered last wins.

So the question is, why you want to disable your sched clock at
compile time.

Thanks,

	tglx
--8323329-193646010-1373040314=:32106--
