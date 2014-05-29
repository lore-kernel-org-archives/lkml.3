Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbaE2LZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:25:14 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:59349 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaE2LZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:25:11 -0400
MIME-Version: 1.0
Date: Thu, 29 May 2014 13:25:10 +0200
X-Google-Sender-Auth: gdMECRO84eTyfwDYcKsDo9lfNRA
Message-ID: <CAJZ5v0jPCdDT-jKCvO67voSkwg_hObZsZMdeFDJ6Wr-aXFR6Ew@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management fixes for v3.15-rc8
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.15-rc8

to receive ACPI and power management fixes for v3.15-rc8 (if
you decide to do -rc8) or for the final v3.15 (otherwise) with
top-most commit 9b961aa99b8155ecc07dd727643ca97424544256

  Merge branches 'pm-cpufreq' and 'acpi-thermal'

on top of commit c7208164e66f63e3ec1759b98087849286410741

  Linux 3.15-rc7

These are three stable-candidate fixes, one for the ACPI thermal
driver and two for cpufreq drivers.

Specifics:

 - A workqueue is destroyed too early during the ACPI thermal driver
   module unload which leads to a NULL pointer dereference in the
   driver's remove callback.  Fix from Aaron Lu.

 - A wrong argument is passed to devm_regulator_get_optional() in
   the probe routine of the cpu0 cpufreq driver which leads to
   resource leaks if the driver is unbound from the cpufreq
   platform device.  Fix from Lucas Stach.

 - A lock is missing in cpufreq_governor_dbs() which leads to
   memory corruption and NULL pointer dereferences during
   system suspend/resume, for example.  Fix from Bibek Basu.

Thanks!


---------------

Aaron Lu (1):
      ACPI / thermal: fix workqueue destroy order

Bibek Basu (1):
      cpufreq: remove race while accessing cur_policy

Lucas Stach (1):
      cpufreq: cpu0: drop wrong devm usage

---------------

 drivers/acpi/thermal.c             |  2 +-
 drivers/cpufreq/cpufreq-cpu0.c     | 16 +++++++++++-----
 drivers/cpufreq/cpufreq_governor.c |  6 ++++++
 3 files changed, 18 insertions(+), 6 deletions(-)
