Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab3HSXas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:30:48 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:8017
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165Ab3HSXar convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:30:47 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI9371Ic89bh1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h906i1155h192ch)
Date: Mon, 19 Aug 2013 16:30:36 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>, <srinivas.kandagatla@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <5204FA5D.3060908@linaro.org>
 <20130809172757.GD14845@codeaurora.org>
 <c1e112a3-cfed-4e53-951e-b1a9208d7dc8@TX2EHSMHS038.ehs.local>
 <52090B43.9090000@codeaurora.org>
 <d36fc2db-1189-4c6a-9bc4-0ac2e29eaa1b@AM1EHSMHS009.ehs.local>
 <5209120D.1010701@linaro.org>
 <9b07d8a3-b650-4147-b952-9bcfc1172c51@VA3EHSMHS025.ehs.local>
 <5209152F.5020307@linaro.org>
 <86b18b0d-08e1-4899-86ea-ed22d3d36dee@DB8EHSMHS028.ehs.local>
 <5212A394.5020109@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5212A394.5020109@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <140fc91a-cc81-418e-8a5e-413bbf47834e@CO1EHSMHS025.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Aug 19, 2013 at 04:00:36PM -0700, Stephen Boyd wrote:
> On 08/16/13 10:28, Sören Brinkmann wrote:
> > On Mon, Aug 12, 2013 at 07:02:39PM +0200, Daniel Lezcano wrote:
> >> On 08/12/2013 06:53 PM, Sören Brinkmann wrote:
> >>> It's actually present. I have a clean 3.11-rc3 and the only changes are
> >>> my patch to enable the GT and Stephen's fix.
> >>> The cpuidle stats show both idle states being used.
> >> Ah, right. The tick_broadcast_mask is not set because the arm global
> >> timer has not the CLOCK_EVT_FEAT_C3STOP feature flag set.
> > Just to check in. Do you want any additional testing done? Or can I
> > expect Stephens fix to get merged, so Zynq can use the GT?
> >
> 
> I was curious, can you use just the first hunk of the patch that applied
> to tick-broadcast.c to fix the problem? I think the answer is yes.

Yes, that seems to be enough.

# cat /proc/interrupts 
           CPU0       CPU1       
 27:         14          1       GIC  27  gt
 29:        664        759       GIC  29  twd
 43:        725          0       GIC  43  ttc_clockevent
 82:        214          0       GIC  82  xuartps
IPI0:          0          0  CPU wakeup interrupts
IPI1:          0         58  Timer broadcast interrupts
IPI2:       1224       1120  Rescheduling interrupts
IPI3:          0          0  Function call interrupts
IPI4:         44         50  Single function call interrupts
IPI5:          0          0  CPU stop interrupts
Err:          0

Timer list:
Tick Device: mode:     1
Broadcast device
Clock Event Device: ttc_clockevent
 max_delta_ns:   1207932479
 min_delta_ns:   18432
 mult:           233015
 shift:          32
 mode:           3
 next_event:     60080000000 nsecs
 set_next_event: ttc_set_next_event
 set_mode:       ttc_set_mode
 event_handler:  tick_handle_oneshot_broadcast
 retries:        0

tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000000

Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: local_timer
 max_delta_ns:   12884902005
 min_delta_ns:   1000
 mult:           715827876
 shift:          31
 mode:           3
 next_event:     59075238755 nsecs
 set_next_event: twd_set_next_event
 set_mode:       twd_set_mode
 event_handler:  hrtimer_interrupt
 retries:        0

Tick Device: mode:     1
Per CPU device: 1
Clock Event Device: local_timer
 max_delta_ns:   12884902005
 min_delta_ns:   1000
 mult:           715827876
 shift:          31
 mode:           3
 next_event:     59080000000 nsecs
 set_next_event: twd_set_next_event
 set_mode:       twd_set_mode
 event_handler:  hrtimer_interrupt
 retries:        0


	Sören


