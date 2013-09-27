Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab3I0IGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:06:10 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60414 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3I0IGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:06:01 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFT PATCH v1 0/7] enable FPSIMD lazy save and restore for arm64
Date: Fri, 27 Sep 2013 16:04:40 +0800
Message-Id: <1380269087-8520-1-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

This patchset enables FPSIMD lazy save and restore for ARM64, you could
apply it against v3.12-rc2.

We have done basic functional tests on ARM fast model, but still lack
of detail performance benchmark on real hardware platforms. We would
appreciate if you could help to test it on really hardware platforms!

The first two patches are bugfixes for current FPSIMD implementations.
The other five patches implements FPSIMD lazy save and restore.

Jiang Liu (7):
  arm64: fix possible invalid FPSIMD initialization state
  arm64: restore FPSIMD to default state for kernel and signal contexts
  arm64: implement basic lazy save and restore for FPSIMD registers
  arm64: provide boot option "eagerfpu" to control FPSIMD restore policy
  arm64: reuse FPSIMD hardware context if possible
  amd64: avoid saving and restoring FPSIMD registers until threads
    access them
  arm64: disable lazy load if FPSIMD registers are frequently used

 Documentation/kernel-parameters.txt |   5 +-
 arch/arm64/include/asm/fpsimd.h     |  12 +-
 arch/arm64/kernel/fpsimd.c          | 217 ++++++++++++++++++++++++++++++++++--
 arch/arm64/kernel/process.c         |   4 +-
 arch/arm64/kernel/signal.c          |  12 +-
 arch/arm64/kernel/signal32.c        |  12 +-
 arch/arm64/kernel/smp.c             |   1 +
 7 files changed, 238 insertions(+), 25 deletions(-)

-- 
1.8.1.2

