Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaF3Qyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:54:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:44293 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbaF3Qya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:54:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,576,1400050800"; 
   d="scan'208";a="536652167"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Chen Gong <gong.chen@linux.jf.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] extlog trace event - queue for 3.17
Date: Mon, 30 Jun 2014 09:54:00 -0700
Message-Id: <53b196284053a30cc@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4d4c9cc839a308be3289a361ccba4447ee140552:

  tracing: Add __field_struct macro for TRACE_EVENT() (2014-06-21 00:18:42 -0400)

[Note this base commit was pulled by Linus between 3.16-rc2 and -rc3]

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-extlog-trace

for you to fetch changes up to 7c76bb5f7a3d052339b873374333dd0dcc35ce28:

  RAS, extlog: Adjust init flow (2014-06-25 13:27:26 -0700)

----------------------------------------------------------------
Report extended error information ("extlog") using
a trace/event.  Provide a mechanism for a smart
daemon collecting this information to tell the kernel
to skip logging corrected errors to the console.

----------------------------------------------------------------
Chen, Gong (7):
      trace, RAS: Add basic RAS trace event
      trace, AER: Move trace into unified interface
      CPER: Adjust code flow of some functions
      RAS, debugfs: Add debugfs interface for RAS subsystem
      trace, RAS: Add eMCA trace event interface
      trace, eMCA: Add a knob to adjust where to save event log
      RAS, extlog: Adjust init flow

 drivers/Kconfig                        |   2 +
 drivers/Makefile                       |   1 +
 drivers/acpi/Kconfig                   |   4 +-
 drivers/acpi/acpi_extlog.c             |  46 ++++++--
 drivers/edac/Kconfig                   |   1 +
 drivers/edac/edac_mc.c                 |   3 -
 drivers/firmware/efi/cper.c            | 192 +++++++++++++++++++++++----------
 drivers/pci/pcie/aer/Kconfig           |   1 +
 drivers/pci/pcie/aer/aerdrv_errprint.c |   4 +-
 drivers/ras/Kconfig                    |   2 +
 drivers/ras/Makefile                   |   1 +
 drivers/ras/debugfs.c                  |  56 ++++++++++
 drivers/ras/ras.c                      |  29 +++++
 include/linux/cper.h                   |  32 ++++++
 include/linux/ras.h                    |  14 +++
 include/ras/ras_event.h                | 128 ++++++++++++++++++++++
 include/trace/events/ras.h             |  77 -------------
 17 files changed, 443 insertions(+), 150 deletions(-)
 create mode 100644 drivers/ras/Kconfig
 create mode 100644 drivers/ras/Makefile
 create mode 100644 drivers/ras/debugfs.c
 create mode 100644 drivers/ras/ras.c
 create mode 100644 include/linux/ras.h
 delete mode 100644 include/trace/events/ras.h
