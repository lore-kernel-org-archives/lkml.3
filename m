Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab3CYQx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:53:59 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.106]:61393 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758086Ab3CYQx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:53:58 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-3.tower-200.messagelabs.com!1364230436!12684411!1
X-Originating-IP: [66.77.174.14]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <5150811F.6070904@digi.com>
Date: Mon, 25 Mar 2013 17:53:51 +0100
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Marek Vasut <marex@denx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: BUG: soft lockup when recording audio on MX28EVK with ASoC sgtl5000
References: <51502C87.8050902@digi.com> <201303251310.55122.marex@denx.de> <20130325152548.GD30232@S2101-09.ap.freescale.net>
In-Reply-To: <20130325152548.GD30232@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 04:25 PM, Shawn Guo wrote:
> On Mon, Mar 25, 2013 at 01:10:54PM +0100, Marek Vasut wrote:
>> Dear Hector Palacios,
>>
>> CCing Shawn, this might also explain the touchscreen issue.
>>
>>> Hello,
>>>
>>> I just tried recording audio on Freescale's MX28EVK that uses ASoC sgtl5000
>>> (kernel v3.8) with:
>>>
>>> 	arecord -M -f cd sound.wav --duration 10
>>>
>>> and got a scheduler message:
>>>
>>> [  789.041847] [sched_delayed] sched: RT throttling activated
>
> Hmm, I'm not sure if v3.8 is the first place where audio recording gets
> broken.  Does v3.7 even work for you?

No it doesn't. Same issue. Apparently a little different order (first the 'BUG soft 
lockup', then the 'sched: RT throttling activated')

~# arecord -M -f cd sound.wav --duration 10
Recording WAVE 'sound.wav' : Signed 16 bit Little Endian, Rate 44100 Hz, Stereo
overrun!!! (at least 0.063 ms long)
[  188.070000] BUG: soft lockup - CPU#0 stuck for 23s! [arecord:230]
[  188.070000] Modules linked in:
[  188.070000] irq event stamp: 2318718
[  188.070000] hardirqs last  enabled at (2318717): [<c000ee68>] __irq_svc+0x48/0x54
[  188.070000] hardirqs last disabled at (2318718): [<c000ee54>] __irq_svc+0x34/0x54
[  188.070000] softirqs last  enabled at (2317860): [<c0025e98>] __do_softirq+0x13c/0x220
[  188.070000] softirqs last disabled at (2317847): [<c002606c>] irq_exit+0x8c/0x94
[  188.070000]
[  188.070000] Pid: 230, comm:              arecord
[  188.070000] CPU: 0    Not tainted  (3.7.0-00027-g46709ea-dirty #8)
[  188.070000] PC is at __flush_whole_cache+0x4/0x18
[  188.070000] LR is at unmap_kernel_range+0x10/0x2c
[  188.070000] pc : [<c001a048>]    lr : [<c00c30d4>]    psr: 00000013
[  188.070000] sp : cf7b3e68  ip : 00000000  fp : 00000000
[  188.070000] r10: 00040000  r9 : cf6d4e00  r8 : c061a7dc
[  188.070000] r7 : d0804000  r6 : d0940000  r5 : d0944000  r4 : d0940000
[  188.070000] r3 : 20000008  r2 : 00000004  r1 : 00004000  r0 : d0940000
[  188.070000] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  188.070000] Control: 0005317f  Table: 4ec2c000  DAC: 00000015
[  188.070000] [<c00151ac>] (unwind_backtrace+0x0/0xf4) from [<c006bd84>] 
(watchdog_timer_fn+0x128/0x168)
[  188.070000] [<c006bd84>] (watchdog_timer_fn+0x128/0x168) from [<c00422cc>] 
(__run_hrtimer+0x7c/0x1e8)
[  188.070000] [<c00422cc>] (__run_hrtimer+0x7c/0x1e8) from [<c00427e4>] 
(hrtimer_interrupt+0x110/0x310)
[  188.070000] [<c00427e4>] (hrtimer_interrupt+0x110/0x310) from [<c001a780>] 
(mxs_timer_interrupt+0x1c/0x28)
[  188.070000] [<c001a780>] (mxs_timer_interrupt+0x1c/0x28) from [<c006c404>] 
(handle_irq_event_percpu+0x5c/0x26c)
[  188.070000] [<c006c404>] (handle_irq_event_percpu+0x5c/0x26c) from [<c006c650>] 
(handle_irq_event+0x3c/0x5c)
[  188.070000] [<c006c650>] (handle_irq_event+0x3c/0x5c) from [<c006ec14>] 
(handle_level_irq+0x8c/0x118)
[  188.070000] [<c006ec14>] (handle_level_irq+0x8c/0x118) from [<c006c398>] 
(generic_handle_irq+0x28/0x30)
[  188.070000] [<c006c398>] (generic_handle_irq+0x28/0x30) from [<c00100fc>] 
(handle_IRQ+0x30/0x84)
[  188.070000] [<c00100fc>] (handle_IRQ+0x30/0x84) from [<c00086ec>] 
(icoll_handle_irq+0x30/0x44)
[  188.070000] [<c00086ec>] (icoll_handle_irq+0x30/0x44) from [<c000ee64>] 
(__irq_svc+0x44/0x54)
[  188.070000] Exception stack(0xcf7b3e20 to 0xcf7b3e68)
[  188.070000] 3e20: d0940000 00004000 00000004 20000008 d0940000 d0944000 d0940000 
d0804000
[  188.070000] 3e40: c061a7dc cf6d4e00 00040000 00000000 00000000 cf7b3e68 c00c30d4 
c001a048
[  188.070000] 3e60: 00000013 ffffffff
[  188.070000] [<c000ee64>] (__irq_svc+0x44/0x54) from [<c001a048>] 
(__flush_whole_cache+0x4/0x18)
[  188.070000] [<c001a048>] (__flush_whole_cache+0x4/0x18) from [<cf76f900>] (0xcf76f900)
[  215.620000] [sched_delayed] sched: RT throttling activated

-- 
Héctor Palacios
