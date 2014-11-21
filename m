Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbaKUOvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:51:31 -0500
Received: from mail-oi0-f50.google.com ([209.85.218.50]:63879 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbaKUOv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:51:29 -0500
MIME-Version: 1.0
Date: Fri, 21 Nov 2014 15:51:28 +0100
X-Google-Sender-Auth: yQED1sj3vCh2EEzFm2q_EXoqGNs
Message-ID: <CAJZ5v0hOVGGt7_cq-tp5LPKaiZ7bF7mtXgyfBwZ7cOWMBb+c0g@mail.gmail.com>
Subject: [GIT PULL] ACPI power management fix for 3.18-rc6
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.18-rc6

to receive an ACPI power management fix for v3.18-rc6 as
commit 78579b7c7eb45f0e7ec5e9437087ed21749f9a9c

 ACPI / PM: Ignore wakeup setting if the ACPI companion can't wake up

on top of commit fc14f9c1272f62c3e8d01300f52467c0d9af50f9

 Linux 3.18-rc5

This is just a one-liner fixing a regression introduced in 3.13 that
broke system suspend on some Chromebooks.

On those machines there are ACPI device objects for some I2C devices
that can wake up the system from sleep states, but that is done via
a platform-specific mechanism and the ACPI objects don't contain any
wakeup-related information.  When we started to use ACPI power
management with those devices (which happened during the 3.13 cycle),
their configuration confused the ACPI PM layer that returned error
codes from suspend callbacks for them causing system suspend to fail.

However, the ACPI PM layer can safely ignore the wakeup setting from
a device driver if the ACPI object corresponding to the device in
question doesn't contain wakeup information in which case the driver
itself is responsible for setting up the device for system wakeup.

Thanks!

---------------

Rafael J. Wysocki (1):
      ACPI / PM: Ignore wakeup setting if the ACPI companion can't wake up

---------------

 drivers/acpi/device_pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
