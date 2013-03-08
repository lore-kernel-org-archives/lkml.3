Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab3CHWbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 17:31:31 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:60248 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab3CHWb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:31:29 -0500
Message-ID: <1362781880.20990.23.camel@thor.lan>
Subject: Re: 3.9.0-rc1+: irq 16: nobody cared
From: Peter Hurley <peter@hurleysoftware.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, linux-pci@vger.kernel.org
Date: Fri, 08 Mar 2013 17:31:20 -0500
In-Reply-To: <1362728271.1220.0.camel@localhost.localdomain>
References: <1362728271.1220.0.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +linux-usb, linux-pci]

This is the 2nd report today for unhandled interrupts with usb hcd.

On Fri, 2013-03-08 at 08:37 +0100, Thomas Meyer wrote:
> [    1.883369] input: C-Media Electronics Inc. USB Multimedia Audio Device as /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1.2/2-1.2:1.3/input/input7
> [    1.883668] hid-generic 0003:0D8C:0105.0001: input,hidraw0: USB HID v1.00 Device [C-Media Electronics Inc. USB Multimedia Audio Device] on usb-0000:00:1d.7-1.2/input3
> [    1.950222] usb 2-1.3: new high-speed USB device number 7 using ehci-pci
> [    1.969193] irq 16: nobody cared (try booting with the "irqpoll" option)
> [    1.969254] Pid: 0, comm: swapper Not tainted 3.9.0-rc1+ #24
> [    1.969256] Call Trace:
> [    1.969258]  <IRQ>  [<ffffffff81098b74>] __report_bad_irq.isra.6+0x24/0xb0
> [    1.969272]  [<ffffffff81098df3>] note_interrupt+0x1a3/0x1f0
> [    1.969276]  [<ffffffff810970d9>] handle_irq_event_percpu+0x89/0x160
> [    1.969281]  [<ffffffff8106ac9d>] ? ktime_get+0x4d/0xd0
> [    1.969286]  [<ffffffff8141bad0>] ? intel_pstate_timer_func+0x370/0x370
> [    1.969290]  [<ffffffff810971d3>] handle_irq_event+0x23/0x40
> [    1.969294]  [<ffffffff81099876>] handle_fasteoi_irq+0x46/0xd0
> [    1.969299]  [<ffffffff8100392d>] handle_irq+0x1d/0x30
> [    1.969303]  [<ffffffff81003822>] do_IRQ+0x52/0xd0
> [    1.969309]  [<ffffffff81513ee8>] common_interrupt+0x68/0x68
> [    1.969311]  <EOI>  [<ffffffff8141c308>] ? cpuidle_wrap_enter+0x48/0x90
> [    1.969318]  [<ffffffff8141c304>] ? cpuidle_wrap_enter+0x44/0x90
> [    1.969323]  [<ffffffff8141c360>] cpuidle_enter_tk+0x10/0x20
> [    1.969326]  [<ffffffff8141c17a>] cpuidle_idle_call+0x7a/0x100
> [    1.969331]  [<ffffffff81009295>] cpu_idle+0x85/0xe0
> [    1.969336]  [<ffffffff815084f2>] rest_init+0x62/0x70
> [    1.969340]  [<ffffffff81a96e06>] start_kernel+0x38b/0x398
> [    1.969344]  [<ffffffff81a9687a>] ? repair_env_string+0x5e/0x5e
> [    1.969348]  [<ffffffff81a965aa>] x86_64_start_reservations+0x2a/0x2c
> [    1.969351]  [<ffffffff81a9667a>] x86_64_start_kernel+0xce/0xd2
> [    1.969353] handlers:
> [    1.969377] [<ffffffff813aded0>] usb_hcd_irq
> [    1.969416] [<ffffffff813aded0>] usb_hcd_irq
> [    1.969452] Disabling IRQ #16
> [    2.047980] usb 2-1.3: New USB device found, idVendor=0b95, idProduct=772a
> [    2.047984] usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    2.047988] usb 2-1.3: Product: AX88x72A
> [    2.047991] usb 2-1.3: Manufacturer: ASIX Elec. Corp.
> [    2.047994] usb 2-1.3: SerialNumber: 555C7C


