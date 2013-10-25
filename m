Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab3JYUKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 16:10:22 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53256 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751774Ab3JYUKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 16:10:20 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management fixes for v3.12-rc7
Date: Fri, 25 Oct 2013 22:22:22 +0200
Message-ID: <6158196.euy954eKxG@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.12-rc7

to receive ACPI and power management fixes for v3.12-rc7 with
top-most commit 75c0758137c7ac647927b4b12bb5cfca96a0e4e6

  acpi-cpufreq: Fail initialization if driver cannot be registered

on top of commit 31d141e3a666269a3b6fcccddb0351caf7454240

  Linux 3.12-rc6

These fix two bugs in the intel_pstate driver, a hibernate bug leading
to nasty resume failures sometimes and acpi-cpufreq initialization bug
that causes problems to happen during module unload when intel_pstate
is in use.

Specifics:

 - Fix for rounding errors in intel_pstate causing CPU utilization to
   be underestimated from Brennan Shacklett.

 - intel_pstate fix to always use the correct max pstate value when
   computing the min pstate from Dirk Brandewie.

 - Hibernation fix for deadlocking resume in cases when the probing
   of the device containing the image is deferred from Russ Dill.

 - acpi-cpufreq fix to prevent the module from staying in memory
   when the driver cannot be registered and then attempting to
   unregister things that have never been registered on exit.

Thanks!


---------------

Brennan Shacklett (1):
      intel_pstate: Improve accuracy by not truncating until final result

Dirk Brandewie (1):
      intel_pstate: Correct calculation of min pstate value

Rafael J. Wysocki (1):
      acpi-cpufreq: Fail initialization if driver cannot be registered

Russ Dill (1):
      PM / hibernate: Move software_resume to late_initcall_sync

---------------

 drivers/cpufreq/acpi-cpufreq.c |  8 ++++----
 drivers/cpufreq/intel_pstate.c | 38 ++++++++++++++++++--------------------
 kernel/power/hibernate.c       |  2 +-
 3 files changed, 23 insertions(+), 25 deletions(-)

