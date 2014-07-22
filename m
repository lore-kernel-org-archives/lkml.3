Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaGVBH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 21:07:57 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60262 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751147AbaGVBHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 21:07:51 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/3] ACPI / PM: Make ACPI-based PCI wakeup work for the "freeze" sleep state
Date: Tue, 22 Jul 2014 03:23:29 +0200
Message-ID: <9631666.En3K0jlGsY@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1907495.agrCMfRsQN@vostro.rjw.lan>
References: <1907495.agrCMfRsQN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 19, 2014 10:36:53 PM Rafael J. Wysocki wrote:
> Hi,
> 
> As per the subject, this is to make ACPI-based PCI wakeup (such as WoL on some
> systems among other things) work with the "freeze" sleep state.  For this
> purpose ACPI wakeup GPEs need to be enabled for wakeup devices before
> freeze_enter() is called and it is best to do that when configuring devices
> for wakeup.
> 
> [1/2] Always enable wakeup GPEs when configuring devices for wakeup
> [2/2] Rename one static function to avoid possible future confusion
> 
> Thanks!

That turned out to be more challenging than I had thought initially.

The last version I sent was almost OK, but it had some issues (like it could
walk the PCI hierarchy before resuming any PCI devices during system resume),
so a new version follows.  I did my best to avoid introducing any new problems
with it, but I obviously might overlook something.

It works for me and doesn't seem to break anything as far as I can say.

[1/3] Make PM workqueue available for CONFIG_PM_RUNTIME unset.
[2/3] Rework the handling of ACPI device wakeup notifications.
[3/3] Enable wakeup GPEs while setting up devices for wakeup during system
      suspend too.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
