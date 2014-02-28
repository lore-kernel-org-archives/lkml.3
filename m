Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaB1XQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 18:16:09 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:58804 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaB1XQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 18:16:07 -0500
MIME-Version: 1.0
Date: Sat, 1 Mar 2014 00:16:05 +0100
X-Google-Sender-Auth: i0deKapQCLRGMyNUvgXLZvJOCq4
Message-ID: <CAJZ5v0jgsEYh8KTUDPmxP5=XSgqDr15hDCWATqE-FT9vS7v_BA@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management fixes for v3.14-rc5
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.14-rc5

to receive ACPI and power management fixes for v3.14-rc5
with top-most commit 6c09ea49ceb8a3b2b709718f6acdb1edd92ea899

  Merge branches 'pm-cpufreq', 'pm-hibernate' and 'acpi-processor'

on top of commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691

  Linux 3.14-rc4

These three commits fix a recent intel_pstate regression and two old
bugs that should be fixed in -stable too, one in the ACPI processor
driver and one in the firmare loader.

Specifics:

 - One of the recent intel_pstate driver fixes introduced a rounding
   error that on some systems causes the frequency to be stuck at the
   lowest level forever.  Fix from Dirk Brandewie.

 - The firmware_class driver's PM notifier doesn't handle the
   PM_RESTORE_PREPARE event during hibernation image restore and that
   leads to a deadlock on umhelper_sem in __usermodehelper_disable().
   Fix from Sebastian Capella.

 - acpi_processor_set_throttling() abuses set_cpus_allowed_ptr() in a
   nasty way which triggers the WARN_ON_ONCE() in wq_worker_waking_up()
   among other things.  Fix from Lan Tianyu.

Thanks!


---------------

Dirk Brandewie (1):
      intel_pstate: Change busy calculation to use fixed point math.

Lan Tianyu (1):
      ACPI / processor: Rework processor throttling with work_on_cpu()

Sebastian Capella (1):
      PM / hibernate: Fix restore hang in freeze_processes()

---------------

 drivers/acpi/processor_throttling.c | 69 +++++++++++++++++--------------------
 drivers/base/firmware_class.c       |  1 +
 drivers/cpufreq/intel_pstate.c      | 28 +++++++++------
 3 files changed, 51 insertions(+), 47 deletions(-)
