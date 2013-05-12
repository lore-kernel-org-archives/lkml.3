Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3ELQSu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 12:18:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33096 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098Ab3ELQSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 12:18:49 -0400
Date: Sun, 12 May 2013 18:18:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Takashi Iwai <tiwai@suse.de>, lkml <linux-kernel@vger.kernel.org>
Subject: irq fun, reloaded
Message-ID: <20130512161847.GA6205@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

you're gonna love this:

This is 3.10-rc1 with "acpi_osi=Linux" on the command line. If I get
bored, I could try to update the BIOS but who knows what else could
break...


[ 8544.664273] ACPI: Preparing to enter system sleep state S5
[ 8544.671948] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via cmdline
[ … ]
[ 8546.393331] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G        W    3.10.0-rc1+ #1
[ 8546.402625] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 EVO R2.0, BIOS 1302 11/15/2012
[ 8546.414602]  ffff880429dc0e88 ffff88042e403e08 ffffffff81588e73 ffff88042e403e38
[ 8546.424198]  ffffffff810b469d ffff88042e403e38 ffff880429dc0e00 0000000000000010
[ 8546.433805]  ffff8804234c0600 ffff88042e403e88 ffffffff810b4b36 ffff88042e403e88
[ 8546.443436] Call Trace:
[ 8546.447950]  <IRQ>  [<ffffffff81588e73>] dump_stack+0x19/0x1b
[ 8546.455856]  [<ffffffff810b469d>] __report_bad_irq+0x3d/0xe0
[ 8546.463609]  [<ffffffff810b4b36>] note_interrupt+0x1a6/0x1f0
[ 8546.471343]  [<ffffffff8133f536>] ? add_interrupt_randomness+0x26/0x180
[ 8546.480006]  [<ffffffff810b233b>] handle_irq_event_percpu+0xcb/0x3a0
[ 8546.488425]  [<ffffffff810b2658>] handle_irq_event+0x48/0x70
[ 8546.496098]  [<ffffffff8158e45d>] ? _raw_spin_lock+0x6d/0x80
[ 8546.503788]  [<ffffffff810b566e>] ? handle_fasteoi_irq+0x1e/0xf0
[ 8546.511801]  [<ffffffff810b56aa>] handle_fasteoi_irq+0x5a/0xf0
[ 8546.519634]  [<ffffffff81004312>] handle_irq+0x22/0x40
[ 8546.526751]  [<ffffffff81591aca>] do_IRQ+0x5a/0xd0
[ 8546.533508]  [<ffffffff8158f5af>] common_interrupt+0x6f/0x6f
[ 8546.541076]  <EOI>  [<ffffffff81440920>] ? cpuidle_enter_state+0x60/0xf0
[ 8546.549818]  [<ffffffff81440924>] ? cpuidle_enter_state+0x64/0xf0
[ 8546.557892]  [<ffffffff81440920>] ? cpuidle_enter_state+0x60/0xf0
[ 8546.565880]  [<ffffffff8144205e>] ? ladder_select_state+0x3e/0x230
[ 8546.574048]  [<ffffffff81440a78>] cpuidle_idle_call+0xc8/0x3b0
[ 8546.581859]  [<ffffffff81098638>] ? trace_hardirqs_off_caller+0x28/0x140
[ 8546.590550]  [<ffffffff8100bfbe>] arch_cpu_idle+0xe/0x30
[ 8546.597840]  [<ffffffff8108cf5c>] cpu_startup_entry+0x8c/0x3e0
[ 8546.605603]  [<ffffffff8157f859>] start_secondary+0x1b7/0x1bb
[ 8546.613327] handlers:
[ 8546.617580] [<ffffffff814aa090>] azx_interrupt
[ 8546.624012] Disabling IRQ #16
[ 8557.927459] acpi_power_off called

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
