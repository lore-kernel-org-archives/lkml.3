Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbaIKORx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:17:53 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:46323 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaIKORr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:17:47 -0400
MIME-Version: 1.0
Date: Thu, 11 Sep 2014 16:17:46 +0200
X-Google-Sender-Auth: _EuQDETU2_LPIRj6GydeAD0TjN0
Message-ID: <CAJZ5v0gdcq5S5qLEY_XAWG3LkfLtz6t_+3XRMqCwehstmd2coQ@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management fixes for 3.17-rc5
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.17-rc5

to receive ACPI and power management fixes for v3.17-rc5 with
top-most commit d2be8992df5d113a57374b7f654d667b8f9b32f4

 Merge branches 'acpi-rtc', 'acpi-lpss' and 'acpi-battery'

on top of commit 2ce7598c9a453e0acd0e07be7be3f5eb39608ebd

 Linux 3.17-rc4

These are regression fixes (cpufreq, ACPI battery) and fixes for
stuff that never worked correctly (ACPI RTC operation region handler
and PM domain implementation in the ACPI LPSS driver).

Specifics:

 - Fix for the cpufreq Operation Performance Points (OPP) code
   where a recent commit added a kcalloc() call with an incorrect
   ordering of arguments.  From Anand Moon.

 - Reverts of two ACPI battery commits that caused incorrect
   diagnostic information to be printed to dmesg in some cases
   from Bjørn Mork.

 - Fix for the ACPI RTC operation region handler that applied the
   & operator to an argument already representing an address and
   that caused it to overwrite its own argument instead of writing
   to the address contained in it as expected.  From Chun-Yi Lee.

 - Fix for the PM domain implementation in the ACPI LPSS (Low-Power
   Subsystem) driver where one callback pointer pointed to a wrong
   routine and one was NULL, but it shouldn't.  From Fu Zhonghui.

Thanks!

---------------

Anand Moon (1):
      cpufreq / OPP: Fix the order of arguments for kcalloc()

Bjørn Mork (2):
      Revert "ACPI / battery: Fix warning message in acpi_battery_get_state()"
      Revert "ACPI / battery: fix wrong value of capacity_now reported
when fully charged"

Fu Zhonghui (1):
      ACPI / LPSS: complete PM entries for LPSS power domain

Lee, Chun-Yi (1):
      ACPI / RTC: Fix CMOS RTC opregion handler accesses to wrong addresses

---------------

 drivers/acpi/acpi_cmos_rtc.c  |  2 +-
 drivers/acpi/acpi_lpss.c      | 10 +++++-----
 drivers/acpi/battery.c        | 14 --------------
 drivers/cpufreq/cpufreq_opp.c |  2 +-
 4 files changed, 7 insertions(+), 21 deletions(-)
