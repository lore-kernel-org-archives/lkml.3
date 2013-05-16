Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab3EPVyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 17:54:22 -0400
Received: from mail-ye0-f170.google.com ([209.85.213.170]:33070 "EHLO
	mail-ye0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3EPVyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 17:54:20 -0400
From: Len Brown <lenb@kernel.org>
To: rjw@sisk.pl
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND] [PATCH 0/2]  Quiet power limit notification
Date: Thu, 16 May 2013 17:54:04 -0400
Message-Id: <1368741246-3998-1-git-send-email-lenb@kernel.org>
X-Mailer: git-send-email 1.8.3.rc2
In-Reply-To: <1368625017-6835-1-git-send-email-fenghua.yu@intel.com>
References: <1368625017-6835-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re-sending for Fenghua, as his e-mail seems to have got lost.
 In case you receive multiple copies, the patches are unchanged.]

thanks,
-Len Brown
Intel Open Source Technology Center
---

Power Limit Notification (X86_FEATURE_PLN) was added in Sandy Bridge
to give the OS the option of knowing when the package has reached
a configured power threshold.

Linux-2.6.36 enabled this feature:
0199114c31798af5b83841b21759b64171060d9b
(x86, hwmon: Package Level Thermal/Power: power limit)

It enabld the interrupt, and the interrupt hander
added to the MCE log and printed to the console:

printk(KERN_CRIT "CPU%d: %s power limit notification (total events = %lu)
printk(KERN_INFO "CPU%d: %s power limit normal\n"

However, these events are quite routine on some systems under some conditions,
alarming customers and provoking un-necessary customer support calls.

So the MCE log entry was deleted in Linux-3.3:

29e9bf1841e4f9df13b4992a716fece7087dd237
(x86, mce, therm_throt: Don't report power limit and package level thermal throttle events in mcelog)

Here we delete the corresponding kernel console messages,
and then we disable the interrupt by default -- allowing it
to be enabled by cmdline for diagnosis purposes.

https://bugzilla.kernel.org/show_bug.cgi?id=36182

This pair of patches applies cleanly back to Linux-3.3.

Documentation/kernel-parameters.txt      |  2 ++
arch/x86/kernel/cpu/mcheck/therm_throt.c | 43 ++++++++++++++++++++++++++-----------------
 2 files changed, 28 insertions(+), 17 deletions(-)

[1/2] x86 thermal: Disable power limit notification interrupt by default
[2/2] x86 thermal: Delete power-limit-notification console messages
