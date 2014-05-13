Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227AbaEMMN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 08:13:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:55475 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759365AbaEMMN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 08:13:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1044,1389772800"; 
   d="scan'208";a="539559773"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mike Turquette <mturquette@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Li Aubrey <aubrey.li@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] ACPI / LPSS: Solution for two issues seen on Asus T100
Date: Tue, 13 May 2014 15:13:49 +0300
Message-Id: <1399983233-18037-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This combines two patch sets for LPSS that I had already send for
review separately. They conflicted with each other.

The first two patches will fix a problem were the context of the
private LPSS registers is lost when entering D3. The last two will add
support for the M/N dividers on LPSS by adding a new basic clock type
for fractional dividers. The UART driver needs support for it in order
to get clock rates that suit the requested baud rates.

I've updated the patch for the fractional divider support according to
Andy's suggestions.


Heikki Krogerus (4):
  ACPI / PM: Export rest of the subsys functions
  ACPI / LPSS: custom power domain for LPSS
  clk: new basic clk type for fractional divider
  ACPI / LPSS: support for fractional divider clock

 drivers/acpi/acpi_lpss.c             | 196 ++++++++++++++++++++++++++++++-----
 drivers/acpi/device_pm.c             |   2 +
 drivers/clk/Makefile                 |   1 +
 drivers/clk/clk-fractional-divider.c | 132 +++++++++++++++++++++++
 include/linux/acpi.h                 |   4 +
 include/linux/clk-provider.h         |  31 ++++++
 6 files changed, 338 insertions(+), 28 deletions(-)
 create mode 100644 drivers/clk/clk-fractional-divider.c

-- 
2.0.0.rc2

