Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965771Ab3FUABb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:01:31 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:22658
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965573Ab3FUABa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:01:30 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zzc89bh4015I14ffIzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh906i1155h192ch)
Date: Thu, 20 Jun 2013 17:01:22 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
CC: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: clocksource with changing frequency?
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <f5e5d3d7-699d-4f89-80c8-849e432e8b26@VA3EHSMHS017.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have a question/problem with a clocksource whose input frequency can
change.
On Zynq we use the cadece_ttc timer as clocksource. Its input clock is
tightly coupled to the CPU clock. I.e. it changes when cpufreq scales
the CPU clocks.
To compensate this, I added a clock notifier doing this on a frequency
change:
	clocksource_unregister(&ttccs->cs);                              
	clocksource_register_hz(&ttccs->cs, ndata->new_rate / PRESCALE);

This just seems not to be the most elegant way, a heavy weight operation
and results in a couple of locking errors in combination with
suspend/hotplug.

Is there a sane solution for such a case? E.g. for clockevent devices
there is a 'clockevents_update_freq()' to adjust to changing
frequencies.

I assume the sanest solution is an external oscillator as clock input,
but I think our platforms don't provide that :(

	Thanks,
	Sören


