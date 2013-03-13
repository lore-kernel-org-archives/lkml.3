Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3CMBcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 21:32:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59897 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab3CMBcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 21:32:04 -0400
X-IronPort-AV: E=Sophos;i="4.84,833,1355126400"; 
   d="scan'208";a="28951501"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 0/3] Detect UDIV/SDIV support from ISAR0
Date: Tue, 12 Mar 2013 18:31:58 -0700
Message-Id: <1363138321-27849-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc2.4.g7799588
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While attempting to upstream a patch to add the IDIV hwcap for
Krait processors, Will suggested we move the code to read the
ISAR0 register. This patchset does that and also works around
the early Krait CPU designs that don't follow the latest ARM ARM
for the ISAR0 register.

Stephen Boyd (3):
  ARM: Clear IDIVT hwcap if CONFIG_ARM_THUMB=n
  ARM: Detect support for SDIV/UDIV from ISAR0 register
  ARM: Work around faulty ISAR0 register in some Krait CPUs

 arch/arm/kernel/setup.c | 30 +++++++++++++++++++++++++++++-
 arch/arm/mm/proc-v7.S   |  4 ++--
 2 files changed, 31 insertions(+), 3 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

