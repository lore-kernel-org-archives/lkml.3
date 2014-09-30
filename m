Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaI3AJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:09:44 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53463 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754869AbaI3AJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:09:17 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Robert Moore <robert.moore@intel.com>
Subject: [PATCH 0/5]: ACPI / PM: Rework wakeup GPE handling for suspend-to-idle
Date: Tue, 30 Sep 2014 02:20:30 +0200
Message-ID: <1622293.rpSt5UtDk3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series is based on the pm-genirq branch of linux-pm.git which has been
included into linux-next for a few weeks.  That branch reworks the handling
of wakeup interrupts in general so that enable_irq_wake() can be used to
indicate that the given interrupt is to be used to wake up from suspend-to-idle
as well as from the other sleep states.  At the same time, using IRQF_NO_SUSPEND
with wakeup interrupts is not regarded as correct any more.

Along these lines, rework the handling of wakeup GPEs for suspend-to-idle so as
to make use of the new mechanism.

This has been tested on Toshiba Portege R500 with ACPI button wakeup and with
ACPI-based PCI Wake-on-LAN.

[1/5] Export dpm_suspend_late(), dpm_suspend_noirq(), dpm_resume_noirq() and
      dpm_resume_early() from the PM core.
[2/5] Rename local functions in the suspend core to better reflect their purpose.
[3/5] Rework ACPICA's acpi_hw_enable_wakeup_gpe_block() to disable all non-wakeup
      GPEs along with enabling the wakeup ones.
[4/5] Introduce acpi_enable_all_wakeup_gpes() in ACPICA (along the lines of the
      analogous function for runtime GPEs).
[5/5] Modify the handling of wakeup GPEs for suspend-to-idle.

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
