Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaBKVpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:45:55 -0500
Received: from canardo.mork.no ([148.122.252.1]:34749 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaBKVpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:45:53 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <52FA9800.9070202@broadcom.com>
References: <52FA9800.9070202@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: IRQ kernel message after upgrade to 3.14-rc1
From: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Date: Tue, 11 Feb 2014 22:45:37 +0100
To: Arend van Spriel <arend@broadcom.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Message-ID: <bf76b3c6-1e1c-43e9-8e1f-fc559f079e5d@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I assume you use the i915 driver? This is a known regression for some chips. Fix is in the i915 repo.


Bjørn

On 11 February 2014 22:37:04 CET, Arend van Spriel <arend@broadcom.com> wrote:
>I upgraded a couple of test rigs for our wireless drivers and noticed
>this blurb showing up in the logs resulting in IRQ to be disabled,
>which
>I doubt is what I want looking at the handlers listed.
>
>Any clue what might be going wrong here. Our isr brcms_isr() either
>returns IRQ_NONE or IRQ_HANDLED.
>
>Let me know what I can do to investigate this.
>
>Regards,
>Arend
>----8<------------------------------------------------------------------
>[377554.333510] cfg80211: Ignoring regulatory request set by core since
>the driver uses its own custom regulatory domain
>[377554.333640] ieee80211 phy1: Selected rate control algorithm
>'minstrel_ht'
>[377554.759284] irq 16: nobody cared (try booting with the "irqpoll"
>option)
>[377554.759295] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           O
>3.14.0-rc1-wl-testing-00002-gadfd26e-dirty #1
>[377554.759299] Hardware name:                  /DG41TY, BIOS
>TYG4110H.86A.0036.2009.1126.2047 11/26/2009
>[377554.759303]  00000000 00000000 f5809f4c c151c571 f5a2b900 f5809f6c
>c109291c c16a9d2c
>[377554.759313]  00000010 00000375 f5d8a5d8 f5a2b900 00000010 f5809f94
>c1092d4a 00000000
>[377554.759322]  00000000 059c6003 00037cd9 9d9abe99 f5a2b900 00000000
>c10936c0 f5809fd8
>[377554.759331] Call Trace:
>[377554.759343]  [<c151c571>] dump_stack+0x41/0x52
>[377554.759350]  [<c109291c>] __report_bad_irq+0x2c/0xd0
>[377554.759356]  [<c1092d4a>] note_interrupt+0x17a/0x1c0
>[377554.759361]  [<c10936c0>] ? unmask_irq+0x30/0x30
>[377554.759366]  [<c1090b92>] handle_irq_event_percpu+0xb2/0x1f0
>[377554.759373]  [<c102ebe3>] ? io_apic_modify_irq.isra.15+0x43/0x60
>[377554.759378]  [<c102ecb0>] ? unmask_ioapic+0x40/0x50
>[377554.759383]  [<c10936c0>] ? unmask_irq+0x30/0x30
>[377554.759388]  [<c1090d03>] handle_irq_event+0x33/0x60
>[377554.759393]  [<c10936c0>] ? unmask_irq+0x30/0x30
>[377554.759398]  [<c109370b>] handle_fasteoi_irq+0x4b/0xd0
>[377554.759401]  <IRQ>  [<c1528a12>] ? do_IRQ+0x42/0xe0
>[377554.759410]  [<c15288ec>] ? common_interrupt+0x2c/0x34
>[377554.759417]  [<c1009a10>] ? default_idle+0x20/0xd0
>[377554.759423]  [<c100a116>] ? arch_cpu_idle+0x26/0x30
>[377554.759428]  [<c109018a>] ? cpu_startup_entry+0x7a/0x230
>[377554.759434]  [<c1515872>] ? rest_init+0x62/0x70
>[377554.759441]  [<c17bba73>] ? start_kernel+0x3a1/0x3a7
>[377554.759446]  [<c17bb50d>] ? repair_env_string+0x51/0x51
>[377554.759451]  [<c17bb358>] ? i386_start_kernel+0x12e/0x131
>[377554.759454] handlers:
>[377554.759458] [<c13df220>] usb_hcd_irq
>[377554.759472] [<f9f1b570>] brcms_isr [brcmsmac]
>[377554.759483] [<f9f1b570>] brcms_isr [brcmsmac]
>[377554.759486] Disabling IRQ #16
>--
>To unsubscribe from this list: send the line "unsubscribe linux-usb" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

