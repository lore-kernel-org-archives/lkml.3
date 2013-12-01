Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab3LAKKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 05:10:43 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54247 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3LAKKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 05:10:36 -0500
Message-ID: <529B0B3E.7040300@gmail.com>
Date: Sun, 01 Dec 2013 11:11:10 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Thomas Gleixner <tglx@linutronix.de>, Jingoo Han <jg1.han@samsung.com>,
        "'Wei WANG'" <wei_wang@realsil.com.cn>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Chris Ball'" <cjb@laptop.org>, "'Borislav Petkov'" <bp@alien8.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
References: <20131117195358.GO27323@pd.tnic> <alpine.DEB.2.02.1311290958560.30673@ionos.tec.linutronix.de> <5299FF38.7060203@gmail.com> <8367476.3aVdCMMH8P@vostro.rjw.lan>
In-Reply-To: <8367476.3aVdCMMH8P@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2013 09:17 PM, Rafael J. Wysocki wrote:
> On Saturday, November 30, 2013 04:07:36 PM Francis Moreau wrote:
>> Hello Thomas,
>>
>> Sorry for the delay.
>>
>> On 11/29/2013 10:02 AM, Thomas Gleixner wrote:
>>> On Fri, 29 Nov 2013, Francis Moreau wrote:
>>>> Since it seems to be related to rtsx driver or its upper layer, could
>>>> the folks involved in this area have a look to this issue please ?
>>>
>>> I'm not involved, but looking at the debug objects backtrace it's
>>> related to the delayed work in rtsx.
>>>
>>> Does the untested patch below cure the issue?
>>>
>>
>> It seems it does since I can't see the debug object trace anymore
>> however Ican see this now:
> 
> So Thomas' patch should be applied to the rtsx driver.
> 
>> [   64.498270] irq 16: nobody cared (try booting with the "irqpoll" option)
>> [   64.498314] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.11.0-rc2-ARCH #65
>> [   64.498316] Hardware name: CLEVO CO.                        W55xEU
>>                        /W55xEU                          , BIOS 4.6.5
>> 03/05/2013
>> [   64.498317]  ffff8804078bd38c ffff88041e203e48 ffffffff81459fe9
>> ffff8804078bd300
>> [   64.498320]  ffff88041e203e70 ffffffff810d8632 ffff8804078bd300
>> 0000000000000010
>> [   64.498322]  0000000000000000 ffff88041e203eb0 ffffffff810d8a58
>> ffffffff8136a882
>> [   64.498324] Call Trace:
>> [   64.498325]  <IRQ>  [<ffffffff81459fe9>] dump_stack+0x54/0x8d
>> [   64.498334]  [<ffffffff810d8632>] __report_bad_irq+0x32/0xd0
>> [   64.498337]  [<ffffffff810d8a58>] note_interrupt+0x138/0x1f0
>> [   64.498340]  [<ffffffff8136a882>] ? cpuidle_enter_state+0x52/0xc0
>> [   64.498343]  [<ffffffff810d6439>] handle_irq_event_percpu+0xf9/0x250
>> [   64.498345]  [<ffffffff810d65cd>] handle_irq_event+0x3d/0x60
>> [   64.498347]  [<ffffffff810d95ca>] handle_fasteoi_irq+0x5a/0x100
>> [   64.498350]  [<ffffffff81004a6e>] handle_irq+0x1e/0x30
>> [   64.498353]  [<ffffffff8146aafd>] do_IRQ+0x4d/0xc0
>> [   64.498355]  [<ffffffff8146116d>] common_interrupt+0x6d/0x6d
>> [   64.498356]  <EOI>  [<ffffffff8136a882>] ? cpuidle_enter_state+0x52/0xc0
>> [   64.498360]  [<ffffffff8136a878>] ? cpuidle_enter_state+0x48/0xc0
>> [   64.498362]  [<ffffffff8136a9b9>] cpuidle_idle_call+0xc9/0x280
>> [   64.498365]  [<ffffffff8100bf6e>] arch_cpu_idle+0xe/0x30
>> [   64.498368]  [<ffffffff810a1287>] cpu_startup_entry+0x257/0x2d0
>> [   64.498370]  [<ffffffff8144d404>] rest_init+0x84/0x90
>> [   64.498373]  [<ffffffff818d9ee1>] start_kernel+0x414/0x420
>> [   64.498375]  [<ffffffff818d98d6>] ? repair_env_string+0x5c/0x5c
>> [   64.498377]  [<ffffffff818d9120>] ? early_idt_handlers+0x120/0x120
>> [   64.498379]  [<ffffffff818d95be>] x86_64_start_reservations+0x2a/0x2c
>> [   64.498381]  [<ffffffff818d96c8>] x86_64_start_kernel+0x108/0x117
>> [   64.498382] handlers:
>> [   64.498402] [<ffffffffa00168f0>] usb_hcd_irq [usbcore]
>> [   64.498422] Disabling IRQ #16
>>
>> So I don't think it completely solve the problem but it's a good start.
> 
> That issue may or may not be related.
> 
> If your system survives resume (I guess it does?), 

my system survives resume as soon as the DEBUG_OBJECTS facility was
activated.

> can you please send
> /proc/interrupts before and after the first suspend/resume cycle?
> 

Sure, I will do later in the day.


Thanks for your help.
