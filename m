Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965700Ab3FTV0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:26:40 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:44704 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965555Ab3FTV0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:26:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [GIT PULL] ACPI fixes for v3.10-rc7
Date: Thu, 20 Jun 2013 23:36 +0200
Message-ID: <1547824.0XkuHTj9ed@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git acpi-3.10-rc7

to receive ACPI fixes for v3.10-rc7 with top-most commit
b9e95fc65ededbec083aa91b4faa58ad992c0891

  ACPI / LPSS: Power up LPSS devices during enumeration

on top of commit 7d132055814ef17a6c7b69f342244c410a5e000f

  Linux 3.10-rc6

One of them fixes a regression introduced on some systems by a recent revert
of an ACPI PM change, two of them fix obvious bugs overlooked in 3.9, and
one fixes a problem reported against the mainline just a couple of days
ago, although the fix itself has been in linux-next since 3.10-rc3.

Specifics:

- Fix for a regression causing a failure to turn on some devices on
  some systems during initialization introduced by a recent revert of
  an ACPI PM change that broke something else.  Fortunately, we know
  exactly what devices are affected, so we can add a fix just for
  them leaving everyone else alone.

- ACPI power resources initialization fix preventing a NULL pointer
  from being dereferenced in the acpi_add_power_resource() error code
  path.

- ACPI dock station driver fix that adds missing locking to
  write_undock().

- ACPI resources allocation fix changing the scope of an old
  workaround so that it doesn't affect systems that aren't actually
  buggy.  This was reported a couple of days ago to fix DMA problems
  on some new platforms so we need it in -stable.  From Mika Westerberg.

Thanks!


---------------

Mika Westerberg (1):
      ACPI / resources: call acpi_get_override_irq() only for legacy IRQ resources

Rafael J. Wysocki (3):
      ACPI / dock: Take ACPI scan lock in write_undock()
      ACPI / PM: Fix error code path for power resources initialization
      ACPI / LPSS: Power up LPSS devices during enumeration

---------------

 drivers/acpi/acpi_lpss.c |   21 +++++++++++++++------
 drivers/acpi/device_pm.c |   20 ++++++++++++++++++++
 drivers/acpi/dock.c      |    2 ++
 drivers/acpi/power.c     |    1 +
 drivers/acpi/resource.c  |   16 +++++++++++-----
 include/acpi/acpi_bus.h  |    1 +
 6 files changed, 50 insertions(+), 11 deletions(-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
