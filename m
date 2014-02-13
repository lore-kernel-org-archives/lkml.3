Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaBMRFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:05:25 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:51760 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751987AbaBMRFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:05:23 -0500
Message-ID: <52FCFB51.5060105@hurleysoftware.com>
Date: Thu, 13 Feb 2014 12:05:21 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: bjoern <lkml@call-home.ch>, linux-kernel@vger.kernel.org
Subject: Re: IRQ nobody cared; Comm: swapper/2 Not tainted
References: <20140211164233.6a94ecc0@ubuntu>
In-Reply-To: <20140211164233.6a94ecc0@ubuntu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi bjoern,

On 02/11/2014 10:42 AM, bjoern wrote:
> Hi,
>
> I just got this dump on my system. It happens occasionally, maybe once
> a week. Result is that my USB keyboard and mouse (both Logitech
> wireless) are laggy, mouse jumps across the screen and keyboard input
> lags behind and creates multiple same keystrokes although the key was
> only hit once.
>
> Ubuntu x64 13.10, Ubuntu kernel 3.13.1 (issue has occured in past also
> when using 3.10/3.11)
>
> [    6.161395] irq 16: nobody cared (try booting with the "irqpoll"
> option)

Are you using the i915 driver? There is a similar report [1] which
apparently has been fixed and will make its way to rc3.

If not, we'll go from there.

Regards,
Peter Hurley

[1] https://lkml.org/lkml/2014/2/11/705

> [    6.161428] CPU: 2 PID: 0 Comm: swapper/2 Not tainted
> 3.13.1-031301-generic #201401291035
> [    6.161429] Hardware
> name:                  /DH61AG, BIOS AGH6110H.86A.0106.2013.0509.1441
> 05/09/2013
> [    6.161431]  ffff880119548e9c ffff88011f303e48 ffffffff8173356d
> 0000000000002652
> [    6.161433]  ffff880119548e00 ffff88011f303e78 ffffffff810c461d
> 0000001c2000af00
> [    6.161435] ffff880119548e00 0000000000000010 0000000000000000
> ffff88011f303ea8
> [    6.161437] Call Trace:
> [    6.161438]  <IRQ> [<ffffffff8173356d>] dump_stack+0x46/0x58
> [    6.161446] [<ffffffff810c461d>] __report_bad_irq+0x3d/0xe0
> [    6.161448] [<ffffffff810c4a4b>] note_interrupt+0x14b/0x1a0
> [    6.161450] [<ffffffff810c2201>] handle_irq_event_percpu+0xb1/0x210
> [    6.161453] [<ffffffff8101d089>] ? sched_clock+0x9/0x10
> [    6.161454] [<ffffffff810c23a8>] handle_irq_event+0x48/0x70
> [    6.161456] [<ffffffff810c568a>] handle_fasteoi_irq+0x5a/0x100
> [    6.161460] [<ffffffff81016f32>] handle_irq+0x22/0x40
> [    6.161463] [<ffffffff8174ad9a>] do_IRQ+0x5a/0xe0
> [    6.161466] [<ffffffff8173ff6d>] common_interrupt+0x6d/0x6d
> [    6.161467] <EOI>
> [<ffffffff815db8e1>] ?cpuidle_enter_state+0x61/0xe0
> [    6.161472] [<ffffffff815db8d7>] ? cpuidle_enter_state+0x57/0xe0
> [    6.161474] [<ffffffff815dba20>] cpuidle_idle_call+0xc0/0x210
> [    6.161477] [<ffffffff8101e4fe>] arch_cpu_idle+0xe/0x30
> [    6.161481] [<ffffffff810c1598>] cpu_idle_loop+0x78/0x270
> [    6.161485]
> [<ffffffff810d6eb2>] ?clockevents_register_device+0xe2/0x140
> [    6.161487] [<ffffffff810c17fb>] cpu_startup_entry+0x6b/0x70
> [    6.161489] [<ffffffff810440e8>] start_secondary+0xc8/0xd0
> [    6.161490] handlers:
> [    6.161505] [<ffffffff81547a40>] usb_hcd_irq
> [    6.161526] Disabling IRQ #16


