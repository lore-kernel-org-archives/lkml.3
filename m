Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaIAOL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:11:56 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52284 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753729AbaIAOL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:11:29 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>,
        Linux PM list <linux-pm@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>, Aubrey Li <aubrey.li@intel.com>
Subject: [PATCH 00/13] genirq / PM: Wakeup interrupts handling rework (related to suspend-to-idle)
Date: Mon, 01 Sep 2014 16:18:47 +0200
Message-ID: <2516134.pmOxkEuOOy@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5320472.coYotHR1d0@vostro.rjw.lan>
References: <26580319.OZP7jvJnA9@vostro.rjw.lan> <5320472.coYotHR1d0@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This set of patches reworks the handling of system wakeup interrupts so that
suspend-to-idle is covered in the same way as full system suspend.

This time we have several new patches from Thomas and hopefully we're nailed
down that thing at last.

[01/13] Mechanism to wake up the system or abort suspend in progress
        automatically (this is different from the previous versions, because
        I eventually convinced myself that pm_abort_suspend didn't really
        require any locking).
[02/13] Move PM-related IRQ code to kernel/irq/pm.c.
[03/13] Add accounting for IRQF_NO_SUSPEND and IRQF_RESUME_EARLY.
[04/13] Use the accoundint added by [03/13].
[05/13] Make suspend_device_irqs() mask non-wakeup interruts if
        IRQCHIP_MASK_ON_SUSPEND is set.
[06/13] Synchronize IRQs in the same loop in which they are reconfigured
        in suspend_device_irqs().
[07/13] Separate irq_check_poll() checks from disabled/no action checks in
        kernel/irq/chip.c.
[08/13] Add a helper for checks made by many IRQ flow handlers in the same way.
[09/13] Mark wakeup sources as "armed" on suspend (using a new flag).
[10/13] Make suspend_device_irqs() leave wakeup interrupts enabled, but handle
        them so that the first interrupt triggers system wakeup.
[11/13] Set IRQCHIP_SKIP_SET_WAKE for x86 IOAPIC IRQ chips (same as before).
[12/13] Make PCIe PME wake up from suspend to idle (same as before).
[13/13] Document rules related to system suspend and interrupts (updated).

The series have been tested on MSI Wind, but more testing is welcome.

There is a pm-genirq branch in the linux-pm.git tree containing these patches:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-genirq

that can be pulled from.

Kind regards,
Rafael

