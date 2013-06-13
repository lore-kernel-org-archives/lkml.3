Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540Ab3FMUQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 16:16:42 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:17911
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756060Ab3FMUQk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 16:16:40 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dIc89bh1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Thu, 13 Jun 2013 13:16:35 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCHv7 01/11] clockevents: Prefer CPU local devices over
 global devices
References: <1370291642-13259-1-git-send-email-sboyd@codeaurora.org>
 <1370291642-13259-2-git-send-email-sboyd@codeaurora.org>
 <51B0A6E8.20909@linaro.org>
 <20130606180425.GQ599@codeaurora.org>
 <51B10D85.1060507@linaro.org>
 <20130606223848.GR599@codeaurora.org>
 <20130612214435.GE10823@codeaurora.org>
 <51B991EF.70800@linaro.org>
 <alpine.LFD.2.02.1306131331430.22970@ionos>
 <20130613183950.GA32061@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130613183950.GA32061@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <999cad28-cd11-489c-91d1-012ffa03b21c@CO9EHSMHS019.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 11:39:50AM -0700, Stephen Boyd wrote:
> On 06/13, Thomas Gleixner wrote:
> > On Thu, 13 Jun 2013, Daniel Lezcano wrote:
> > > I prefer Thomas to have a look at it and ack it. I changed Cc to To for
> > > Thomas.
> > 
> > The patch does not apply on tip timers/core. The code has been
> > reworked a month ago. Please work against tip timers/core. That's
> > where this stuff ends up.
> > 
> 
> Ah, I thought your patch series had stalled. Here is a refreshed
> patch. Every other patch in this series applies cleanly to tip
> timers/core so I don't want to resend them again unless
> absolutely necessary.
> 
> -----8<-----
> Subject: [PATCH v8] clockevents: Prefer CPU local devices over global devices
> 
> On an SMP system with only one global clockevent and a dummy
> clockevent per CPU we run into problems. We want the dummy
> clockevents to be registered as the per CPU tick devices, but
> we can only achieve that if we register the dummy clockevents
> before the global clockevent or if we artificially inflate the
> rating of the dummy clockevents to be higher than the rating
> of the global clockevent. Failure to do so leads to boot
> hangs when the dummy timers are registered on all other CPUs
> besides the CPU that accepted the global clockevent as its tick
> device and there is no broadcast timer to poke the dummy
> devices.
> 
> If we're registering multiple clockevents and one clockevent is
> global and the other is local to a particular CPU we should
> choose to use the local clockevent regardless of the rating of
> the device. This way, if the clockevent is a dummy it will take
> the tick device duty as long as there isn't a higher rated tick
> device and any global clockevent will be bumped out into
> broadcast mode, fixing the problem described above.
> 
> Reported-by: Mark Rutland <mark.rutland@arm.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Tested-by: Sören Brinkmann <soren.brinkmann@xilinx.com>

I retested my case on tip/timers/core with the same results.

	Sören


