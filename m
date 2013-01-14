Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab3ANOpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 09:45:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:28063 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477Ab3ANOpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 09:45:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,468,1355126400"; 
   d="scan'208";a="190892201"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: [PATCH 0/3] x86: enable common clk and add support for Lynxpoint clocks
Date: Mon, 14 Jan 2013 16:46:25 +0200
Message-Id: <1358174788-24439-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The discussion that lead to this patch series starts from the below thread:

	http://thread.gmane.org/gmane.linux.kernel/1417691

In summary, there is no point in adding a special case code to the drivers
in order to pass them a fixed clock rate, but instead x86 should just
enable common clk subsystem and take advantage of it.

This has been proposed before by Mark Brown but for some reason it has not
merged into x86 tree.

This series tries to do the same but in this time we have real users for
the clk API.

[1/3] Enables the common clk framework on x86
[2/3] Adds Intel Lynxpoint Low Power Subsystem specific clocks as platform
      driver.
[3/3] Creates the platform device for the LPSS clocks driver if we find out
      that the Lynxpoint LPSS devices are available.

This series is based on Rafael's linux-pm/linux-next branch because there
is a dependency to the ACPI scan rework by Rafael.

Please review.

Mika Westerberg (3):
  x86: enable common clk on x86
  clk: x86: add support for Lynxpoint LPSS clocks
  ACPI: create Lynxpoint clocks if LPSS devices are found during scan

 arch/x86/Kconfig           |    1 +
 drivers/acpi/scan.c        |   36 ++++++++++++----
 drivers/clk/Makefile       |    1 +
 drivers/clk/x86/Makefile   |    2 +
 drivers/clk/x86/clk-lpss.c |   99 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/x86/clk-lpss.h |   36 ++++++++++++++++
 drivers/clk/x86/clk-lpt.c  |   86 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 252 insertions(+), 9 deletions(-)
 create mode 100644 drivers/clk/x86/Makefile
 create mode 100644 drivers/clk/x86/clk-lpss.c
 create mode 100644 drivers/clk/x86/clk-lpss.h
 create mode 100644 drivers/clk/x86/clk-lpt.c

-- 
1.7.10.4

