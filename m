Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3IYPhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:37:34 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:26404
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753492Ab3IYPhc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:37:32 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371Ic89bh1432I14ffIdb82hzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh906i1155h192ch)
Date: Wed, 25 Sep 2013 08:37:19 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Preeti Murthy <preeti.lkml@gmail.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 0/4] arm: zynq: Enable global timer
References: <1379530118-22813-1-git-send-email-soren.brinkmann@xilinx.com>
 <5242FF4B.6050901@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5242FF4B.6050901@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <06680eeb-11e3-4fdc-99f7-1b57c06deb11@CO1EHSMHS021.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 05:20:43PM +0200, Daniel Lezcano wrote:
> On 09/18/2013 08:48 PM, Soren Brinkmann wrote:
> > Hi all,
> > 
> > here's a v2. I reused the subject from my v1 submission although the focus of
> > this series moved a bit towards the timer subsystem.
> > I replaced Stephen's fix to prevent per cpu devices from becoming
> > the broadcast device with Thomas' proposal, but I kept the original commit
> > message. I split the whole approach in small chunks that I found reasonable.
> > 
> > In 4/4, I picked up Grant's comment regarding the DT node name.
> > 
> > v2:
> >  - drop 1/2 of the original series
> >  - implement preventing per cpu devices from becoming broadcast device according
> >    to Thomas' proposal
> >    - introduce new CLOCK_EVT_FEAT_PERCPU flag
> >    - set the flag for the arm_global_timer
> >    - filter per cpu devices based on this flag when choosing the broadcast
> >      device
> >  - rename DT node to avoid '_'s
> >  
> > 
> > Soren Brinkmann (4):
> >   clockchips: Add FEAT_PERCPU clockevent flag
> >   clocksource/arm_global_timer: Set FEAT_PERCPU flag
> >   tick: broadcast: Deny per-cpu clockevents from being broadcast sources
> >   arm: zynq: Enable arm_global_timer
> > 
> >  arch/arm/boot/dts/zynq-7000.dtsi       | 8 ++++++++
> >  arch/arm/mach-zynq/Kconfig             | 1 +
> >  drivers/clocksource/arm_global_timer.c | 3 ++-
> >  include/linux/clockchips.h             | 1 +
> >  kernel/time/tick-broadcast.c           | 1 +
> >  5 files changed, 13 insertions(+), 1 deletion(-)
> 
> This patches falls under different maintainer's umbrella.
> 
> I acked-by the patches, so if someone is willing to take the patches I
> am ok with that. I am ok also to pick them into my tree with the
> acked-by maintainer. Just let me know ...

Thanks Daniel. I agree you/timer folks and Michal/armsoc have to figure
out how to resolve this the easiest way. I'd almost say merging this all
through the timers tree might be the easiest. The conflict which might
occur in the Zynq dts file should be trivial since the patch is purely
additive.

But well, up to you.

	Sören


