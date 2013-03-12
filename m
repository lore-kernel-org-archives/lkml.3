Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab3CLT4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:56:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27342 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab3CLT4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:56:44 -0400
Date: Tue, 12 Mar 2013 15:56:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.9-rc2-tag
Message-ID: <20130312195637.GA22439@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.9-rc2-tag

which has three compile fixes - two are for errors on ARM, and
there is one warning on x86. Then there is run-time WARNING
in the xen-pciback. The last one is a regression fix - where
the acpi_processor_register_performance (used in the Xen
ACPI P-and-C states uploader) started returning -ENODEV when cpuidle API
is turned off (previous to v3.9 cpuidle API would return -ENODEV for
some of its functions when it was off, but not all) - Rafael
preferred that it got through my tree, so here it is.

Please pull!

Ian Campbell (1):
      xen: arm: mandate EABI and use generic atomic operations.

Konrad Rzeszutek Wilk (2):
      xen/pciback: Don't disable a PCI device that is already disabled.
      acpi: Export the acpi_processor_get_performance_info

Liu Jinsong (1):
      xen/acpi: remove redundant acpi/acpi_drivers.h include

 arch/arm/Kconfig                      |  3 ++-
 arch/arm/include/asm/xen/events.h     | 25 ++++---------------------
 drivers/acpi/processor_perflib.c      |  4 ++--
 drivers/xen/xen-acpi-processor.c      |  8 ++++----
 drivers/xen/xen-pciback/pciback_ops.c |  3 ++-
 drivers/xen/xen-stub.c                |  1 -
 include/acpi/processor.h              |  3 +++
 7 files changed, 17 insertions(+), 30 deletions(-)
