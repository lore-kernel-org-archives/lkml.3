Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaDWBk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:40:27 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:21916 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaDWBk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:40:26 -0400
X-IronPort-AV: E=Sophos;i="4.97,908,1389772800"; 
   d="scan'208";a="25836714"
From: Zi Shen Lim <zlim@broadcom.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Brown <broonie@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>
CC: Zi Shen Lim <zlim@broadcom.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] arm64 topology updates
Date: Tue, 22 Apr 2014 18:40:12 -0700
Message-ID: <1398217214-12204-1-git-send-email-zlim@broadcom.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First patch in this series purges unused mc_capable() and smt_capable(),
similar to what went into 3.15-rc1 for other architectures. [1]

Since this is fairly straightforward, please pick this one up soon, so
we're in line with other architectures.

Second patch in this series adds MPIDR-based detection of cpu topology.
MPIDR support is independent of topology information from DT or ACPI.
MPIDR should always work for hardware that sets those bits with sane values.

For cpu topology, MPIDR can be used as default method or as fallback for
DT or ACPI. I lean towards MPIDR as default (at least on host/hypervisor),
but will leave it up to the maintainers on detection priority :)

I've tested this on my model with MT and it works for me.
The code should cover known use cases. I hope to get confirmation,
or more discussions, from others.

This series applies on 3.15-rc1.

Note that this series is functionally orthogonal to the series Mark Brown
just posted. In off-list discussion with Mark, he's currently focusing on
DT-related bits. For reference, his patches are:

  [PATCH 1/4] arm64: topology: Initialise default topology state immediately
  [PATCH 2/4] arm64: topology: Add support for topology DT bindings
  [PATCH 3/4] arm64: topology: Tell the scheduler about the relative power of cores
  [PATCH 4/4] arm64: topology: Provide relative power numbers for cores

Thanks,
z

References:
[1] Clean up from Bjorn Helgaas 36fc5500bb19 ("sched: Remove unused
    mc_capable() and smt_capable()"). Link: https://lkml.org/lkml/2014/3/11/463

Links to Mark's series:
[1/4] http://www.spinics.net/lists/arm-kernel/msg324508.html
[2/4] http://www.spinics.net/lists/arm-kernel/msg324507.html
[3/4] http://www.spinics.net/lists/arm-kernel/msg324505.html
[4/4] http://www.spinics.net/lists/arm-kernel/msg324506.html

Zi Shen Lim (2):
  arm64, sched: Remove unused mc_capable() and smt_capable()
  arm64: topology: add MPIDR-based detection

 arch/arm64/include/asm/cputype.h  |  2 ++
 arch/arm64/include/asm/topology.h |  3 ---
 arch/arm64/kernel/topology.c      | 31 +++++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 3 deletions(-)

-- 
1.8.4.3

