Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbaKTXH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 18:07:59 -0500
Received: from mga03.intel.com ([134.134.136.65]:9916 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917AbaKTXH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 18:07:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,426,1413270000"; 
   d="scan'208";a="640796273"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>, x86@kernel.org
Subject: [GIT PULL] Couple more changes for x86/ras branch
Date: Thu, 20 Nov 2014 15:07:57 -0800
Message-Id: <546e744d25585e3421@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8dcf32ea220d87ca517e164de85d336480c9d172:

  x86, MCE, AMD: Assign interrupt handler only when bank supports it (2014-11-01 11:28:23 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-ucna

for you to fetch changes up to fa92c58694268a7e9f7fa2c6881c1482221c2788:

  x86, mce: Support memory error recovery for both UCNA and Deferred error in machine_check_poll (2014-11-19 10:56:51 -0800)

----------------------------------------------------------------
Handle all uncorrected error reports in the same way (soft offline
the page). We used to only do that for SRAO (software recoverable
action optional) machine checks, but it makes sense to also do it
for UCNA (UnCorrected No Action) logs found by CMCI or polling.

----------------------------------------------------------------
Chen Yucong (2):
      x86, mce, severity: Extend the the mce_severity mechanism to handle UCNA/DEFERRED error
      x86, mce: Support memory error recovery for both UCNA and Deferred error in machine_check_poll

 arch/x86/include/asm/mce.h                |  4 +++
 arch/x86/kernel/cpu/mcheck/mce-internal.h |  4 ++-
 arch/x86/kernel/cpu/mcheck/mce-severity.c | 23 ++++++++----
 arch/x86/kernel/cpu/mcheck/mce.c          | 60 +++++++++++++++++++++++++++----
 drivers/edac/mce_amd.h                    |  3 --
 5 files changed, 78 insertions(+), 16 deletions(-)
