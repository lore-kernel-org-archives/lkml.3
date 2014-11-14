Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161055AbaKNPFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:05:53 -0500
Received: from mail-oi0-f47.google.com ([209.85.218.47]:35366 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935310AbaKNPFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:05:50 -0500
MIME-Version: 1.0
Date: Fri, 14 Nov 2014 16:05:49 +0100
X-Google-Sender-Auth: UIqAdwMRKLAx4aNWELvR64oGYIE
Message-ID: <CAJZ5v0hpu+tdc06_zz+5K-RmuTD+oy_Z9nJZtyXKafQD+Rrv5w@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management fixes for 3.18-rc5
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.18-rc5

to receive ACPI and power management fixes for v3.18-rc5 with
top-most commit 31689497d90e589d7050fc7bc850b4b46e632bfc

 Merge branches 'pm-domains', 'pm-sleep' and 'pm-cpufreq'

on top of commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108

 Linux 3.18-rc4

These are three regression fixes, two recent (generic power domains,
suspend-to-idle) and one older (cpufreq), an ACPI blacklist entry for
one more machine having problems with Windows 8 compatibility, a
minor cpufreq driver fix (cpufreq-dt) and a fixup for new callback
definitions (generic power domains).

Specifics:

 - Fix a crash in the suspend-to-idle code path introduced by a
   recent commit that forgot to check a pointer against NULL before
   dereferencing it (Dmitry Eremin-Solenikov).

 - Fix a boot crash on Exynos5 introduced by a recent commit making
   that platform use generic Device Tree bindings for power domains
   which exposed a weakness in the generic power domains framework
   leading to that crash (Ulf Hansson).

 - Fix a crash during system resume on systems where cpufreq depends
   on Operation Performance Points (OPP) for functionality, but
   CONFIG_OPP is not set.  This leads the cpufreq driver registration
   to fail, but the resume code attempts to restore the pre-suspend
   cpufreq configuration (which does not exist) nevertheless and
   crashes.  From Geert Uytterhoeven.

 - Add a new ACPI blacklist entry for Dell Vostro 3546 that has
   problems if it is reported as Windows 8 compatible to the BIOS
   (Adam Lee).

 - Fix swapped arguments in an error message in the cpufreq-dt
   driver (Abhilash Kesavan).

 - Fix up the prototypes of new callbacks in struct generic_pm_domain
   to make them more useful.  Users of those callbacks will be added
   in 3.19 and it's better for them to be based on the correct struct
   definition in mainline from the start.  From Ulf Hansson and
   Kevin Hilman.

Thanks!


---------------

Abhilash Kesavan (1):
      cpufreq: cpufreq-dt: Fix arguments in clock failure error message

Adam Lee (1):
      ACPI / blacklist: blacklist Win8 OSI for Dell Vostro 3546

Dmitry Eremin-Solenikov (1):
      PM / sleep: Fix entering suspend-to-IDLE if no freeze_oops is set

Geert Uytterhoeven (1):
      cpufreq: Avoid crash in resume on SMP without OPP

Ulf Hansson (2):
      PM / Domains: Change prototype for the attach and detach callbacks
      PM / Domains: Fix initial default state of the need_restore flag

---------------

 drivers/acpi/blacklist.c     |  8 ++++++++
 drivers/base/power/domain.c  | 42 ++++++++++++++++++++++++++++++++++--------
 drivers/cpufreq/cpufreq-dt.c |  4 ++--
 drivers/cpufreq/cpufreq.c    |  3 ++-
 include/linux/pm_domain.h    |  8 +++++---
 kernel/power/suspend.c       |  4 ++--
 6 files changed, 53 insertions(+), 16 deletions(-)
