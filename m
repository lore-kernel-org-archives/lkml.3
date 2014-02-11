Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaBKVhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:37:13 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:9627 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaBKVhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:37:08 -0500
X-IronPort-AV: E=Sophos;i="4.95,827,1384329600"; 
   d="scan'208";a="14381852"
Message-ID: <52FA9800.9070202@broadcom.com>
Date: Tue, 11 Feb 2014 22:37:04 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: IRQ kernel message after upgrade to 3.14-rc1
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I upgraded a couple of test rigs for our wireless drivers and noticed
this blurb showing up in the logs resulting in IRQ to be disabled, which
I doubt is what I want looking at the handlers listed.

Any clue what might be going wrong here. Our isr brcms_isr() either
returns IRQ_NONE or IRQ_HANDLED.

Let me know what I can do to investigate this.

Regards,
Arend
----8<------------------------------------------------------------------
[377554.333510] cfg80211: Ignoring regulatory request set by core since
the driver uses its own custom regulatory domain
[377554.333640] ieee80211 phy1: Selected rate control algorithm
'minstrel_ht'
[377554.759284] irq 16: nobody cared (try booting with the "irqpoll" option)
[377554.759295] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           O
3.14.0-rc1-wl-testing-00002-gadfd26e-dirty #1
[377554.759299] Hardware name:                  /DG41TY, BIOS
TYG4110H.86A.0036.2009.1126.2047 11/26/2009
[377554.759303]  00000000 00000000 f5809f4c c151c571 f5a2b900 f5809f6c
c109291c c16a9d2c
[377554.759313]  00000010 00000375 f5d8a5d8 f5a2b900 00000010 f5809f94
c1092d4a 00000000
[377554.759322]  00000000 059c6003 00037cd9 9d9abe99 f5a2b900 00000000
c10936c0 f5809fd8
[377554.759331] Call Trace:
[377554.759343]  [<c151c571>] dump_stack+0x41/0x52
[377554.759350]  [<c109291c>] __report_bad_irq+0x2c/0xd0
[377554.759356]  [<c1092d4a>] note_interrupt+0x17a/0x1c0
[377554.759361]  [<c10936c0>] ? unmask_irq+0x30/0x30
[377554.759366]  [<c1090b92>] handle_irq_event_percpu+0xb2/0x1f0
[377554.759373]  [<c102ebe3>] ? io_apic_modify_irq.isra.15+0x43/0x60
[377554.759378]  [<c102ecb0>] ? unmask_ioapic+0x40/0x50
[377554.759383]  [<c10936c0>] ? unmask_irq+0x30/0x30
[377554.759388]  [<c1090d03>] handle_irq_event+0x33/0x60
[377554.759393]  [<c10936c0>] ? unmask_irq+0x30/0x30
[377554.759398]  [<c109370b>] handle_fasteoi_irq+0x4b/0xd0
[377554.759401]  <IRQ>  [<c1528a12>] ? do_IRQ+0x42/0xe0
[377554.759410]  [<c15288ec>] ? common_interrupt+0x2c/0x34
[377554.759417]  [<c1009a10>] ? default_idle+0x20/0xd0
[377554.759423]  [<c100a116>] ? arch_cpu_idle+0x26/0x30
[377554.759428]  [<c109018a>] ? cpu_startup_entry+0x7a/0x230
[377554.759434]  [<c1515872>] ? rest_init+0x62/0x70
[377554.759441]  [<c17bba73>] ? start_kernel+0x3a1/0x3a7
[377554.759446]  [<c17bb50d>] ? repair_env_string+0x51/0x51
[377554.759451]  [<c17bb358>] ? i386_start_kernel+0x12e/0x131
[377554.759454] handlers:
[377554.759458] [<c13df220>] usb_hcd_irq
[377554.759472] [<f9f1b570>] brcms_isr [brcmsmac]
[377554.759483] [<f9f1b570>] brcms_isr [brcmsmac]
[377554.759486] Disabling IRQ #16
