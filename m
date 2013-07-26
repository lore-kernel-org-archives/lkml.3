Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458Ab3GZVPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:15:09 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42317 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932979Ab3GZVPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 17:15:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, intel-gfx@lists.freedesktop.org
Subject: [GIT PULL] ACPI and power management fixes for v3.11-rc3
Date: Fri, 26 Jul 2013 23:25:06 +0200
Message-ID: <3457206.NODt6ENkDb@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.11-rc3

to receive ACPI and power management fixes for v3.11-rc3 with
top-most commit 8e5c2b776ae4c35f54547c017e0a943429f5748a

  Revert "ACPI / video / i915: No ACPI backlight if firmware expects Windows 8"

on top of commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b

  Linux 3.11-rc2

These are just two fixes, a revert of the would-be backlight fix that didn't
work and an intel_pstate fix for two problems related to maximum P-state
selection.

Specifics:

- Revert of the ACPI video commit that I hoped would help fix
  backlight problems related to Windows 8 compatibility on some
  systems.  Unfortunately, it turned out to cause problems to happen
  too.

- Fix for two problems in intel_pstate, a possible failure to respond
  to a load change on a quiet system and a possible failure to select
  the highest available P-state on some systems.  From Dirk Brandewie.

Thanks!


---------------

Dirk Brandewie (1):
      cpufreq / intel_pstate: Change to scale off of max P-state

Rafael J. Wysocki (1):
      Revert "ACPI / video / i915: No ACPI backlight if firmware expects Windows 8"

---------------

 drivers/acpi/internal.h         |    2 --
 drivers/acpi/video.c            |   67 ++++++-----------------------------------------
 drivers/acpi/video_detect.c     |   15 +----------
 drivers/cpufreq/intel_pstate.c  |   12 ++++-----
 drivers/gpu/drm/i915/i915_dma.c |    2 +-
 include/acpi/video.h            |   11 +-------
 include/linux/acpi.h            |    1 -
 7 files changed, 17 insertions(+), 93 deletions(-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
