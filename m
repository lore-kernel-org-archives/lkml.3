Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbbANIWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:22:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:6808 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbbANIWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:22:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,754,1413270000"; 
   d="scan'208";a="661592385"
From: Ong Boon Leong <boon.leong.ong@intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mfd, lpc_sch: Intel Quark X1000 WDT enabling
Date: Wed, 14 Jan 2015 16:20:19 +0800
Message-Id: <1421223621-22385-1-git-send-email-boon.leong.ong@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	This patch simply adds WDT IO resource for Quark within lpc_sch driver.
The MFD driver would register 'ie6xx_wdt' platform device and eventually be bound
to its platform driver under drivers/watchdog/ie6xx_wdt.c

	I have tested this patch on Intel Quark Galileo Gen v2 boad by opening
/dev/watchdog0 and confirmed that the board undergo warm reset when time-out.

	I can read the debugfs for the driver by following command:-
		$ cat /sys/kernel/debug/ie6xx_wdt

	To modify the time-out value, we use kernel param:-
		ie6xx_wdt.timeout=<val in second>

	To activate warm reset & enable reset, we use kernel param:-
		ie6xx_wdt.resetmode=0x18

Thank you very much
Ong Boon Leong
Intel Corp.

Ong Boon Leong (1):
  mfd: lpc_sch: enable WDT for Intel Quark X1000

 drivers/mfd/lpc_sch.c |    1
 1 file changed, 1 insertion(+)

-- 
1.7.9.5

