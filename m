Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab3EFO1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:27:34 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:32852 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3EFO1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:27:33 -0400
MIME-Version: 1.0
In-Reply-To: <1367527692-25809-1-git-send-email-ddaney.cavm@gmail.com>
References: <CA+55aFwDGyHOzu=Qh7SJOBK6QvAwAh7pMDL6LfMUE=AW_kapAw@mail.gmail.com>
 <1367527692-25809-1-git-send-email-ddaney.cavm@gmail.com>
From: Manuel Lauss <manuel.lauss@gmail.com>
Date: Mon, 6 May 2013 16:26:52 +0200
Message-ID: <CAOLZvyFo8OWD4qXDCQwJOWn0Hgs35XEF2pDppSbPt3Fnb3j9GQ@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Enable interrupts before WAIT instruction.
To: David Daney <ddaney.cavm@gmail.com>
Cc: Linux-MIPS <linux-mips@linux-mips.org>, Ralf Baechle <ralf@linux-mips.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jonas Gorski <jogo@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, May 2, 2013 at 10:48 PM, David Daney <ddaney.cavm@gmail.com> wrote:
> From: David Daney <david.daney@cavium.com>
>
> As noted by Thomas Gleixner:
>
>    commit cdbedc61c8 (mips: Use generic idle loop) broke MIPS as I did
>    not realize that MIPS wants to invoke the wait instructions with
>    interrupts enabled.
>
> Instead of enabling interrupts in arch_cpu_idle() as Thomas' initial
> patch does, we follow Linus' suggestion of doing it in the assembly
> code to prevent the compiler from rearranging things.
>
> Signed-off-by: David Daney <david.daney@cavium.com>
> Reported-by: EunBong Song <eunb.song@samsung.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jonas Gorski <jogo@openwrt.org>
> ---
>
> This is only very lightly tested, we need more testing before
> declaring it the definitive fix.
>
>  arch/mips/kernel/genex.S | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Unfortunately this patch doesn't work for me, system just hangs at
certain points
during kernel startup.  Reverting the patch above fixes it, but with
this warning:

ehci-platform ehci-platform.0: irq 98, io mem 0x14020000
------------[ cut here ]------------
WARNING: at /home/mano/db1200/kernel/linux/kernel/cpu/idle.c:96
cpu_startup_entry+0x138/0x184()
CPU: 0 PID: 0 Comm: swapper Not tainted 3.9.0-db1235-10522-g6295a89 #2
Stack : 00000000 00000000 809b4462 00000046 80929c20 00000000 808c6504 00000000
          808c3428 80929b27 80929dc8 00000000 809b3c04 00000000
00000000 00000000
          80093348 807d1000 2cb41780 8011f458 00000000 00000000
808c4a28 8091fe24
          00000000 00000000 00000000 00000000 00000000 00000000
00000000 00000000
          00000000 00000000 00000000 00000000 00000000 00000000
00000000 8091fdb0
          ...
Call Trace:
[<8010a1fc>] show_stack+0x64/0x7c
[<8011f614>] warn_slowpath_common+0x70/0xa0
[<8011f700>] warn_slowpath_null+0x18/0x28
[<80150464>] cpu_startup_entry+0x138/0x184
[<809658f0>] start_kernel+0x360/0x378

---[ end trace 19427144468f733d ]---
ehci-platform ehci-platform.0: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found


Thanks,
      Manuel
