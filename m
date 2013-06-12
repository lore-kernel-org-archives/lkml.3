Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab3FLWaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 18:30:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33242 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab3FLWaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 18:30:11 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 0/3] Remove msm_iomap for 8x60 and 8960
Date: Wed, 12 Jun 2013 15:30:05 -0700
Message-Id: <1371076208-30921-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.251.g1462b67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset moves the MSM code over to DEBUG_LL_INCLUDE
as well as removes the rest of the static mappings made on
8x60 and 8960. This allows us to remove the msm_iomap-8x60.h
msm_iomap-8960.h. Note that debug_ll_io_init() will
be the default in 3.11 so we'll have to make a sweep in the merge
window or after to remove those two.

Patches are based on David Brown's MSM for-next tree.

git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git for-next

Changes since v1:
 * Fixed mapping on 7x00
 * Fixed compile on 7k where uart mappings are used by devices files

Stephen Boyd (3):
  ARM: msm: Move debug-macro.S to include/debug
  ARM: msm: Remove TMR and TMR0 static mappings
  ARM: msm: Don't compile __msm_ioremap_caller() unless used

 arch/arm/Kconfig.debug                             |  9 ++-
 .../mach/debug-macro.S => include/debug/msm.S}     | 32 ++++++++++-
 arch/arm/mach-msm/board-dt-8660.c                  |  3 +-
 arch/arm/mach-msm/board-dt-8960.c                  |  3 +-
 arch/arm/mach-msm/common.h                         |  2 -
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h    | 46 ----------------
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h    | 49 -----------------
 arch/arm/mach-msm/include/mach/msm_iomap.h         | 17 ------
 arch/arm/mach-msm/include/mach/uncompress.h        | 63 ---------------------
 arch/arm/mach-msm/io.c                             | 64 +++++++---------------
 10 files changed, 62 insertions(+), 226 deletions(-)
 rename arch/arm/{mach-msm/include/mach/debug-macro.S => include/debug/msm.S} (61%)
 delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8960.h
 delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
 delete mode 100644 arch/arm/mach-msm/include/mach/uncompress.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

