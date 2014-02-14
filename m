Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaBNNjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 08:39:14 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:47376 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbaBNNjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 08:39:13 -0500
MIME-Version: 1.0
Date: Fri, 14 Feb 2014 14:39:11 +0100
X-Google-Sender-Auth: 5naLDyC_4vsF_NhAOuRq0OJrSrE
Message-ID: <CAJZ5v0jNWGKqQKozyqWeJnGReKLrzArfrWOntHEaXaJ1R_B7xw@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management fixes for v3.14-rc3
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.14-rc3

to receive ACPI and power management fixes for v3.14-rc3
with top-most commit 465e5fc41dbeeb5331bbff6e9e734f0542dfc739

  Merge branch 'pm-cpufreq'

on top of commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed

  Linux 3.14-rc2

These include a fix for a recent intel_pstate regression, a fix for
a regression in the ACPI-based PCI hotplug (ACPIPHP) code introduced
during the 3.12 cycle, fixes for two bugs in the ACPI core introduced
recently and a MAINTAINERS update related to cpufreq.

Specifics:

 - Fix for a recent regression in the intel_pstate driver that
   introduced a race condition causing systems to crash during
   initialization in some situations.  This removes the affected
   code altogether.  From Dirk Brandewie.

 - ACPIPHP fix for a regression introduced during the 3.12 cycle
   causing devices to be dropped as a result of bus check notifications
   after system resume on some systems due to the way ACPIPHP interprets
   _STA return values (arguably incorrectly).  From Mika Westerberg.

 - ACPI dock driver fix for a problem causing docking to fail due to
   a check that always fails after recent ACPI core changes (found by
   code inspection).

 - ACPI container driver fix to prevent memory from being leaked in
   an error code path after device_register() failures.

 - Update of the arm_big_little cpufreq driver maintainer's e-mail
   address.

Thanks!


---------------

Dirk Brandewie (1):
      intel_pstate: Remove energy reporting from pstate_sample tracepoint

Mika Westerberg (1):
      ACPI / hotplug / PCI: Relax the checking of _STA return values

Rafael J. Wysocki (2):
      ACPI / dock: Use acpi_device_enumerated() to check if dock is present
      ACPI / container: Fix error code path in container_device_attach()

Sudeep Holla (1):
      MAINTAINERS / cpufreq: update Sudeep's email address

---------------

 MAINTAINERS                        |  2 +-
 drivers/acpi/container.c           |  5 +++--
 drivers/acpi/dock.c                |  5 +++--
 drivers/cpufreq/intel_pstate.c     |  9 ---------
 drivers/pci/hotplug/acpiphp_glue.c | 15 +++++++++++++--
 include/trace/events/power.h       |  7 +------
 6 files changed, 21 insertions(+), 22 deletions(-)
