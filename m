Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab3CRS3C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:29:02 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26361 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab3CRS3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:29:00 -0400
X-IronPort-AV: E=Sophos;i="4.84,865,1355126400"; 
   d="scan'208";a="30399941"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCHv2 0/3] Detect UDIV/SDIV support from ISAR0
Date: Mon, 18 Mar 2013 11:28:54 -0700
Message-Id: <1363631337-13816-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc2.4.g7799588
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While attempting to upstream a patch to add the IDIV hwcap for
Krait processors, Will suggested we move the code to read the
ISAR0 register. This patchset does that and also works around
the early Krait CPU designs that don't follow the latest ARM ARM
for the ISAR0 register.

Stepan Moskovchenko (1):
  ARM: Work around faulty ISAR0 register in some Krait CPUs

Stephen Boyd (2):
  ARM: Clear IDIVT hwcap if CONFIG_ARM_THUMB=n
  ARM: Detect support for SDIV/UDIV from ISAR0 register

 arch/arm/kernel/setup.c | 22 +++++++++++++++++++++-
 arch/arm/mm/proc-v7.S   | 19 +++++++++++++++++--
 2 files changed, 38 insertions(+), 3 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

