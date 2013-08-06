Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab3HFQSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 12:18:49 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:9141
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755863Ab3HFQSs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 12:18:48 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371Ic89bh146fI1432I1447Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Tue, 6 Aug 2013 09:18:32 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Stuart Menefy <stuart.menefy@st.com>, Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <068436c6-ff98-428f-8875-bb1c6f86466b@TX2EHSMHS008.ehs.local>
 <51F97CE3.9030306@linaro.org>
 <15e19315-ce88-4d3c-bad9-0a37d9e52f6b@CO1EHSMHS007.ehs.local>
 <51F99747.4060901@linaro.org>
 <a48f159a-e88c-42fa-b76b-662302d3a585@AM1EHSMHS003.ehs.local>
 <51FA9AE8.1060004@linaro.org>
 <1c83c081-60c6-49e3-a85c-f64dd5be0e60@CH1EHSMHS030.ehs.local>
 <51FA9F54.3060704@linaro.org>
 <712d31e9-3584-48e1-aa9f-55bc94fa62c9@DB9EHSMHS001.ehs.local>
 <5200B7FE.4000306@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5200B7FE.4000306@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <ff0f72c1-9868-4c11-869c-05c9e7aa5f0c@DB9EHSMHS022.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 10:46:54AM +0200, Daniel Lezcano wrote:
> On 08/06/2013 03:28 AM, Sören Brinkmann wrote:
> > Hi Daniel,
> > 
> > On Thu, Aug 01, 2013 at 07:48:04PM +0200, Daniel Lezcano wrote:
> >> On 08/01/2013 07:43 PM, Sören Brinkmann wrote:
> >>> On Thu, Aug 01, 2013 at 07:29:12PM +0200, Daniel Lezcano wrote:
> >>>> On 08/01/2013 01:38 AM, Sören Brinkmann wrote:
> >>>>> On Thu, Aug 01, 2013 at 01:01:27AM +0200, Daniel Lezcano wrote:
> >>>>>> On 08/01/2013 12:18 AM, Sören Brinkmann wrote:
> >>>>>>> On Wed, Jul 31, 2013 at 11:08:51PM +0200, Daniel Lezcano wrote:
> >>>>>>>> On 07/31/2013 10:58 PM, Sören Brinkmann wrote:
> >>>>>>>>> On Wed, Jul 31, 2013 at 10:49:06PM +0200, Daniel Lezcano wrote:
> >>>>>>>>>> On 07/31/2013 12:34 AM, Sören Brinkmann wrote:
> >>>>>>>>>>> On Tue, Jul 30, 2013 at 10:47:15AM +0200, Daniel Lezcano wrote:
> >>>>>>>>>>>> On 07/30/2013 02:03 AM, Sören Brinkmann wrote:
> >>>>>>>>>>>>> Hi Daniel,
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> On Mon, Jul 29, 2013 at 02:51:49PM +0200, Daniel Lezcano wrote:
> >>>>>>>>>>>>> (snip)
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> the CPUIDLE_FLAG_TIMER_STOP flag tells the cpuidle framework the local
> >>>>>>>>>>>>>> timer will be stopped when entering to the idle state. In this case, the
> >>>>>>>>>>>>>> cpuidle framework will call clockevents_notify(ENTER) and switches to a
> >>>>>>>>>>>>>> broadcast timer and will call clockevents_notify(EXIT) when exiting the
> >>>>>>>>>>>>>> idle state, switching the local timer back in use.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> I've been thinking about this, trying to understand how this makes my
> >>>>>>>>>>>>> boot attempts on Zynq hang. IIUC, the wrongly provided TIMER_STOP flag
> >>>>>>>>>>>>> would make the timer core switch to a broadcast device even though it
> >>>>>>>>>>>>> wouldn't be necessary. But shouldn't it still work? It sounds like we do
> >>>>>>>>>>>>> something useless, but nothing wrong in a sense that it should result in
> >>>>>>>>>>>>> breakage. I guess I'm missing something obvious. This timer system will
> >>>>>>>>>>>>> always remain a mystery to me.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> Actually this more or less leads to the question: What is this
> >>>>>>>>>>>>> 'broadcast timer'. I guess that is some clockevent device which is
> >>>>>>>>>>>>> common to all cores? (that would be the cadence_ttc for Zynq). Is the
> >>>>>>>>>>>>> hang pointing to some issue with that driver?
> >>>>>>>>>>>>
> >>>>>>>>>>>> If you look at the /proc/timer_list, which timer is used for broadcasting ?
> >>>>>>>>>>>
> >>>>>>>>>>> So, the correct run results (full output attached).
> >>>>>>>>>>>
> >>>>>>>>>>> The vanilla kernel uses the twd timers as local timers and the TTC as
> >>>>>>>>>>> broadcast device:
> >>>>>>>>>>> 	Tick Device: mode:     1                                                         
> >>>>>>>>>>> 	Broadcast device  
> >>>>>>>>>>> 	Clock Event Device: ttc_clockevent
> >>>>>>>>>>>
> >>>>>>>>>>> When I remove the offending CPUIDLE flag and add the DT fragment to
> >>>>>>>>>>> enable the global timer, the twd timers are still used as local timers
> >>>>>>>>>>> and the broadcast device is the global timer:
> >>>>>>>>>>> 	Tick Device: mode:     1                                                         
> >>>>>>>>>>> 	Broadcast device                                                                 
> >>>>>>>>>>> 	Clock Event Device: arm_global_timer
> >>>>>>>>>>>
> >>>>>>>>>>> Again, since boot hangs in the actually broken case, I don't see way to
> >>>>>>>>>>> obtain this information for that case.
> >>>>>>>>>>
> >>>>>>>>>> Can't you use the maxcpus=1 option to ensure the system to boot up ?
> >>>>>>>>>
> >>>>>>>>> Right, that works. I forgot about that option after you mentioned, that
> >>>>>>>>> it is most likely not that useful.
> >>>>>>>>>
> >>>>>>>>> Anyway, this are those sysfs files with an unmodified cpuidle driver and
> >>>>>>>>> the gt enabled and having maxcpus=1 set.
> >>>>>>>>>
> >>>>>>>>> /proc/timer_list:
> >>>>>>>>> 	Tick Device: mode:     1
> >>>>>>>>> 	Broadcast device
> >>>>>>>>> 	Clock Event Device: arm_global_timer
> >>>>>>>>> 	 max_delta_ns:   12884902005
> >>>>>>>>> 	 min_delta_ns:   1000
> >>>>>>>>> 	 mult:           715827876
> >>>>>>>>> 	 shift:          31
> >>>>>>>>> 	 mode:           3
> >>>>>>>>
> >>>>>>>> Here the mode is 3 (CLOCK_EVT_MODE_ONESHOT)
> >>>>>>>>
> >>>>>>>> The previous timer_list output you gave me when removing the offending
> >>>>>>>> cpuidle flag, it was 1 (CLOCK_EVT_MODE_SHUTDOWN).
> >>>>>>>>
> >>>>>>>> Is it possible you try to get this output again right after onlining the
> >>>>>>>> cpu1 in order to check if the broadcast device switches to SHUTDOWN ?
> >>>>>>>
> >>>>>>> How do I do that? I tried to online CPU1 after booting with maxcpus=1
> >>>>>>> and that didn't end well:
> >>>>>>> 	# echo 1 > online && cat /proc/timer_list 
> >>>>>>
> >>>>>> Hmm, I was hoping to have a small delay before the kernel hangs but
> >>>>>> apparently this is not the case... :(
> >>>>>>
> >>>>>> I suspect the global timer is shutdown at one moment but I don't
> >>>>>> understand why and when.
> >>>>>>
> >>>>>> Can you add a stack trace in the "clockevents_shutdown" function with
> >>>>>> the clockevent device name ? Perhaps, we may see at boot time an
> >>>>>> interesting trace when it hangs.
> >>>>>
> >>>>> I did this change:
> >>>>> 	diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> >>>>> 	index 38959c8..3ab11c1 100644
> >>>>> 	--- a/kernel/time/clockevents.c
> >>>>> 	+++ b/kernel/time/clockevents.c
> >>>>> 	@@ -92,6 +92,8 @@ void clockevents_set_mode(struct clock_event_device *dev,
> >>>>> 	  */
> >>>>> 	 void clockevents_shutdown(struct clock_event_device *dev)
> >>>>> 	 {
> >>>>> 	+       pr_info("ce->name:%s\n", dev->name);
> >>>>> 	+       dump_stack();
> >>>>> 	        clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
> >>>>> 	        dev->next_event.tv64 = KTIME_MAX;
> >>>>> 	 }
> >>>>>
> >>>>> It is hit a few times during boot, so I attach a full boot log. I really
> >>>>> don't know what to look for, but I hope you can spot something in it. I
> >>>>> really appreciate you taking the time.
> >>>>
> >>>> Thanks for the traces.
> >>>
> >>> Sure.
> >>>
> >>>>
> >>>> If you try without the ttc_clockevent configured in the kernel (but with
> >>>> twd and gt), does it boot ?
> >>>
> >>> Absence of the TTC doesn't seem to make any difference. It hangs at the
> >>> same location.
> >>
> >> Ok, IMO there is a problem with the broadcast device registration (may
> >> be vs twd).
> >>
> >> I will check later (kid duty) :)
> > 
> > I was actually waiting for an update from your side and did something
> > else, but I seem to have run into this again. I was overhauling the
> > cadence_ttc (patch attached, based on tip/timers/core). And it seems to
> > show the same behavior as enabling the global_timer. With cpuidle off, it
> > works. With cpuidle, on it hangs. Removing the TIMER_STOP flag from the
> > C2 state makes it boot again.
> > It works just fine on our 3.10 kernel.
> 
> This is not necessary related to the bug. If the patch you sent broke
> the cadence_ttc driver, when you use it (with the TIMER_STOP), you will
> be stuck. Removing the flag, may signifies you don't use the broadcast
> timer, hence the bug is not surfacing.
> 
> Going back to the bug with the arm_global_timer, what is observed is the
> broadcast timer is *shutdown* when the second cpu is online.
> 
> I have to dig into the kernel/time/clockevents.c|tick-*.c because IMO
> the issue is coming from there but before I have to reproduce the bug,
> so find a board I have where I can add the arm_global_timer.
> 
> > Another thing I noticed - probably unrelated but hard to tell: On
> > 3.11-rc1 and later my system stops for quite some time at the hand off
> > to userspace. I.e. I see the 'freeing unused kernel memory...' line and
> > sometimes the following 'Welcome to Buildroot...' and then it stops and
> > on good kernels it continues after a while and boots through and on bad
> > ones it just hangs there.
> 
> did you try to dump the stacks with magic-sysrq ? Or git bisect ?

That's my plan for today. Trying to find a reasonable approach for
bisecting some of this stuff.

	Sören


