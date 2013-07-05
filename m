Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab3GEVKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 17:10:20 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:32817
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752274Ab3GEVKT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 17:10:19 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dIc89bh1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Fri, 5 Jul 2013 14:10:04 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Baruch Siach <baruch@tkos.co.il>, John Stultz <john.stultz@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Michal Simek <michal.simek@xilinx.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] clocksource/cadence_ttc: Reuse clocksource as sched_clock
References: <1372888216-10726-1-git-send-email-soren.brinkmann@xilinx.com>
 <20130704033026.GX4288@tarshish>
 <0030b826-0eb1-4bb8-a0de-1d8dc68bd81a@TX2EHSMHS017.ehs.local>
 <alpine.DEB.2.02.1307052238170.32106@ionos.tec.linutronix.de>
 <4fab6223-45c5-453e-9972-1c12aa79a312@CO1EHSMHS008.ehs.local>
 <alpine.DEB.2.02.1307052259090.32106@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307052259090.32106@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <db965b9f-740b-4ea6-9219-09ece1fc9220@CO9EHSMHS013.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 10:59:53PM +0200, Thomas Gleixner wrote:
> On Fri, 5 Jul 2013, Sören Brinkmann wrote:
> > On Fri, Jul 05, 2013 at 10:42:03PM +0200, Thomas Gleixner wrote:
> > > We have a mechanism for that in place, if stuff goes cross trees. One
> > > of the trees provides a set of commit for the other tree to pull, so
> > > we do not end up with merge dependencies and conflicts.
> > > 
> > > Why is clocksource stuff going through armsoc unless it contains
> > > related modifications in arch/arm/
> > We overhauled Zynq's common clock code and migrated all Zynq drivers to
> > it - the TTC being one. I'm pretty sure you were on the CC list for that
> > change.
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=30e1e28598c2674c133148d8aec6d431d7acd314
> > 
> 
> That's fine as it has no dependencies on any of the clocksource core
> changes AFAICT.
Right, shouldn't be a big deal. Just for this patch, I currently have the
choice of working with the old TTC but the new clocksource core or the
other way around. But since everything is going to meet in Linus' tree
soon, I just wait a bit until tip/timers is merged.

	Sören


