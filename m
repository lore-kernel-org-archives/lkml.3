Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab3EaPzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:55:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:23531 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab3EaPzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:55:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,779,1363158000"; 
   d="scan'208";a="249147302"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lance.ortiz@hp.com
Subject: [GIT PULL] Fix aer error logging
Date: Fri, 31 May 2013 08:54:59 -0700
Message-Id: <51a8c7d311309a525@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e4aa937ec75df0eea0bee03bffa3303ad36c986b:

  Linux 3.10-rc3 (2013-05-26 16:00:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-aertracefix

for you to fetch changes up to 37448adfc7ce0d6d5892b87aa8d57edde4126f49:

  aerdrv: Move cper_print_aer() call out of interrupt context (2013-05-30 10:51:20 -0700)

----------------------------------------------------------------
Can't call pci_get_domain_bus_and_slot() from interupt context

----------------------------------------------------------------
Lance Ortiz (1):
      aerdrv: Move cper_print_aer() call out of interrupt context

 drivers/acpi/apei/cper.c               | 18 ------------------
 drivers/acpi/apei/ghes.c               |  4 +++-
 drivers/pci/pcie/aer/aerdrv_core.c     |  5 ++++-
 drivers/pci/pcie/aer/aerdrv_errprint.c |  4 ++--
 include/linux/aer.h                    |  5 +++--
 5 files changed, 12 insertions(+), 24 deletions(-)
