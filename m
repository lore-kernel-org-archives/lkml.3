Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab3F1Q7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:59:05 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:21760
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511Ab3F1Q7C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:59:02 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Stehle Vincent-B46079 <B46079@freescale.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: RE: next-20130627 breaks i.MX6 sabre sd UART console
Thread-Topic: next-20130627 breaks i.MX6 sabre sd UART console
Thread-Index: Ac5zZxBZeupdDlSIRDWI6ggVo3oJ5QAkUYcAAAf2xwAAAZFOUA==
Date: Fri, 28 Jun 2013 16:58:58 +0000
Message-ID: <F7C43F8B2814514CA05F3436BC68046EF2297D@039-SN2MPN1-013.039d.mgd.msft.net>
References: <F7C43F8B2814514CA05F3436BC68046EF1EB72@039-SN2MPN1-013.039d.mgd.msft.net>
 <alpine.DEB.2.02.1306281403530.4013@ionos.tec.linutronix.de>
 <51CDB26A.9060500@codeaurora.org>
In-Reply-To: <51CDB26A.9060500@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [88.178.86.202]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: linux-next-owner@vger.kernel.org [mailto:linux-next-owner@vger.kernel.org] On Behalf Of Stephen Boyd
(..)
> Do you have debug_ll support to get some serial logs?

Hi,

Thanks for your concern on the matter. You are right, there is debug_ll support for i.MX6. If I activate it for next-20130628 imx_v6_v7_defconfig, that only "buys" me one additional line, though:

  Uncompressing Linux... done, booting the kernel.

> Also could you try booting with maxcpus=1 on the kernel commandline?

Good idea; it goes much further with this one (until it crashes in wm8962_probe(), which is as far as I go when I revert 064706514ec3fea740c2656e03c4f01f6a551ac4).

> And it would be useful to have the output of /proc/timer_list if you have it from a working device.

Sure; I pasted it below.

> I believe you have a per-cpu TWD timer and a global imx-gpt?

I think you are right from what I see in /proc/interrupts.

> Can you try this patch? (sorry about the whitespace damage)

Sorry, this patch had no visible effect.

Best regards,

V.

--- /proc/timer_list ---
Timer List Version: v0.7
HRTIMER_MAX_CLOCK_BASES: 4
now at 104544862569 nsecs

cpu: 0
 clock 0:
  .base:       80fcc5a0
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <80fcc720>, tick_sched_timer, S:01
 # expires at 104550000000-104550000000 nsecs [in 5138067 to 5138067 nsecs]
 #1: <bf869a98>, hrtimer_wakeup, S:01
 # expires at 108088808660-108093808657 nsecs [in 3543946727 to 3548946724 nsecs]
 #2: <bf27df28>, hrtimer_wakeup, S:01
 # expires at 152209022299-152209072299 nsecs [in 47664160366 to 47664210366 nsecs]
 #3: <bfb91910>, it_real_fn, S:01
 # expires at 389697029617-389697029617 nsecs [in 285152167684 to 285152167684 nsecs]
 #4: <bf305a98>, hrtimer_wakeup, S:01
 # expires at 86489728463860-86489828463860 nsecs [in 86385183601927 to 86385283601927 nsecs]
 clock 1:
  .base:       80fcc5d8
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     31109466222080 nsecs
active timers:
 clock 2:
  .base:       80fcc610
  .index:      2
  .resolution: 1 nsecs
  .get_time:   ktime_get_boottime
  .offset:     0 nsecs
active timers:
 clock 3:
  .base:       80fcc648
  .index:      3
  .resolution: 1 nsecs
  .get_time:   ktime_get_clocktai
  .offset:     31109466222080 nsecs
active timers:
  .expires_next   : 104550000000 nsecs
  .hres_active    : 1
  .nr_events      : 4632
  .nr_retries     : 0
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 2
  .last_tick      : 104530000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 4294947748
  .idle_calls     : 12180
  .idle_sleeps    : 1193
  .idle_entrytime : 104542811418 nsecs
  .idle_waketime  : 104531758281 nsecs
  .idle_exittime  : 104531841675 nsecs
  .idle_sleeptime : 81643279539 nsecs
  .iowait_sleeptime: 5577955342 nsecs
  .last_jiffies   : 4294947750
  .next_jiffies   : 4294947751
  .idle_expires   : 104560000000 nsecs
jiffies: 4294947750

Tick Device: mode:     1
Broadcast device
Clock Event Device: <NULL>
tick_broadcast_mask: 00000000
tick_broadcast_oneshot_mask: 00000000

Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: mxc_timer1
 max_delta_ns:   65075261923
 min_delta_ns:   3863
 mult:           141733921
 shift:          31
 mode:           3
 next_event:     104550000000 nsecs
 set_next_event: v2_set_next_event
 set_mode:       mxc_set_mode
 event_handler:  hrtimer_interrupt
 retries:        0


