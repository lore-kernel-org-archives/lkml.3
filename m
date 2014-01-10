Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaAJNms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 08:42:48 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64640 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751151AbaAJNmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:42:43 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management fixes for v3.13-rc8
Date: Fri, 10 Jan 2014 14:56:34 +0100
Message-ID: <3636626.qYgrmslayD@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.13-rc8

to receive ACPI and power management fixes for 3.13-rc8
with top-most commit 13de22c59fd1f5a452fea806a5f822883deec88b

  Merge branch 'pm-cpuidle'

on top of commit d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc

  Linux 3.13-rc7

These include two fixes for recent regressions in intel_idle, a fix for
a recent regression in the ACPI AC driver and three commits for stable
(intel_pstate fixup, tpm_ppi memory leak fix and an ACPI battery quirk).
All simple stuff.

This should be the last ACPI/PM batch for 3.13.

Specifics:

- Recent commits modifying the lists of C-states in the intel_idle
  driver introduced bugs leading to crashes on some systems.  Two
  fixes from Jiang Liu.

- The ACPI AC driver should receive all types of notifications, but
  recent change made it ignore some of them.  Fix from Alexander Mezin.

- intel_pstate's validity checks for MSRs it depends on are not
  sufficient to catch the lack of support in nested KVM setups, so
  they are extended to cover that case.  From Dirk Brandewie.

- NEC LZ750/LS has a botched up _BIX method in its ACPI tables, so our
  ACPI battery driver needs a quirk for it.  From Lan Tianyu.

- The tpm_ppi driver sometimes leaks memory allocated by acpi_get_name().
  Fix from Jiang Liu.

Thanks!


---------------

Alexander Mezin (1):
      ACPI / AC: change notification handler type to ACPI_ALL_NOTIFY

Dirk Brandewie (1):
      intel_pstate: Add X86_FEATURE_APERFMPERF to cpu match parameters.

Jiang Liu (3):
      ACPI / TPM: fix memory leak when walking ACPI namespace
      Revert "intel_idle: mark states tables with __initdata tag"
      intel_idle: close avn_cstates array with correct marker

Lan Tianyu (1):
      ACPI / Battery: Add a _BIX quirk for NEC LZ750/LS

---------------

 drivers/acpi/ac.c              |  4 ++--
 drivers/acpi/battery.c         | 22 +++++++++++++++++++++-
 drivers/char/tpm/tpm_ppi.c     | 15 +++++++++------
 drivers/cpufreq/intel_pstate.c |  3 ++-
 drivers/idle/intel_idle.c      | 14 ++++++++------
 5 files changed, 42 insertions(+), 16 deletions(-)

