Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751020AbaKCFQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 00:16:17 -0500
Received: from mga03.intel.com ([134.134.136.65]:55199 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbaKCFQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 00:16:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,305,1413270000"; 
   d="scan'208";a="630108933"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 0/6] ACPI/EC: Cleanups of command flushing and event polling.
Date: Mon,  3 Nov 2014 13:16:07 +0800
Message-Id: <cover.1414988981.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains 2 cleanups related to the EC driver:
1. Command flushing
   This patchset flushes EC commands before suspending/resuming, so that
   there won't be timeout for the incomplete commands after resuming.
2. Event polling thread
   It is not proper to send QR_EC command using the same work queue as
   the _Qxx/_Lxx/_Exx evaluations. This patchset moves the QR_EC issuing to
   a seperate thread. This also allows us to extend the EC driver in the
   future to be aware of the events even when SCI_EVT is failed to be set
   by the firmware.

This patchset is split from an EC GPE storming prevention enhancement
series. The original discussion can be found at:
  http://www.spinics.net/lists/linux-acpi/msg51698.html

Lv Zheng (6):
  ACPI/EC: Introduce STARTED/STOPPED flags to replace BLOCKED flag.
  ACPI/EC: Enhance the checks to apply to QR_EC transactions.
  ACPI/EC: Add reference counting for query handlers.
  ACPI/EC: Add command flushing support.
  ACPI/EC: Cleanup QR_SC command processing by adding a kernel thread
    to poll EC events.
  ACPI/EC: Add GPE reference counting debugging messages.

 drivers/acpi/ec.c       |  379 ++++++++++++++++++++++++++++++++++++++---------
 drivers/acpi/internal.h |    2 +
 2 files changed, 313 insertions(+), 68 deletions(-)

-- 
1.7.10

