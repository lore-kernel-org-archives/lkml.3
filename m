Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaGHHHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:07:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46035 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaGHHHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:07:50 -0400
Date: Tue, 8 Jul 2014 09:07:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: 3.16-rc1: oops in restore_all
Message-ID: <20140708070748.GA4011@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I just got this:

BUG: unable to handle kernel paging request at f55fa004
IP: [<c480cf01>] restore_all+0x4/0x18
*pde = 373ef067 *pte = 355fa060 
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
Modules linked in:
CPU: 1 PID: 23071 Comm: chromium-browse Not tainted 3.16.0-rc1-test+
#5
Hardware name:                  /DG41MJ, BIOS
MJG4110H.86A.0006.2009.1223.1155 12/23/2009
task: e81ee590 ti: e79c4000 task.ti: e79c4000
EIP: 0060:[<c480cf01>] EFLAGS: 00210092 CPU: 1
EIP is at restore_all+0x4/0x18
EAX: 00200082 EBX: e79c5f90 ECX: c400557d EDX: 7c0eb000
ESI: b08a94a1 EDI: c403cd70 EBP: e79c5f98 ESP: f55f9fc4
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
CR0: 80050033 CR2: f55fa004 CR3: 28321000 CR4: 00040790
Stack:
 e79c5f90 e81ee590 00406040 b08a94a1 c403cd70 e79c5f98 00406040
 e79c007b
 020e007b 000000d8 e79c00e0 00406040 c4003fa5 00000060 00200082
Call Trace:
 [<c403cd70>] ? __local_bh_enable+0x40/0x40
 [<c4003fa5>] ? do_softirq_own_stack+0x25/0x40
 <IRQ> 
 [<c403ccee>] irq_exit+0x6e/0xb0
 [<c4028d25>] smp_apic_timer_interrupt+0x35/0x40
 [<c480d62d>] apic_timer_interrupt+0x31/0x38
 [<c4800000>] ? minstrel_get_rate+0xa0/0x220
Code: 00 ff 14 85 a0 01 81 c4 89 44 24 18 50 51 52 e8 b6 92 86 ff 5a
59 58 fa 8b 4d 08 f7 c1 ff fe 08 10 0f 85 cf 00 00 00 8b 44 24 38 <8a>
64 24 40 8a 44 24 34 25 03 04 02 00 3d 03 04 00 00 74 11 5b
EIP: [<c480cf01>] restore_all+0x4/0x18 SS:ESP 0068:f55f9fc4
CR2: 00000000f55fa004
---[ end trace 158ea93b46c4600c ]---
pavel@amd:~$ uname -a
Linux amd 3.16.0-rc1-test+ #5 SMP Sat Jun 21 21:12:53 CEST 2014 i686
GNU/Linux

I guess I should not really run -rc1 kernels when -rc4 is available...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
