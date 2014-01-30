Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbaA3QSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:18:06 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:49972 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbaA3QSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:18:03 -0500
From: =?UTF-8?q?Adrien=20Verg=C3=A9?= <adrienverge@gmail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: =?UTF-8?q?Adrien=20Verg=C3=A9?= <adrienverge@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Christopher Covington <cov@codeaurora.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Michel Dagenais <michel.dagenais@polymtl.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 0/5] ARM CoreSight: ETM: Fix a vmalloc/vfree failure and enhance tracing control
Date: Thu, 30 Jan 2014 11:11:05 -0500
Message-Id: <1391098270-8867-1-git-send-email-adrienverge@gmail.com>
X-Mailer: git-send-email 1.8.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Different ARM users have shown their interest in this patch, so I made
a third version that is compatible with PID namespaces.

Mainly:
- It fixes a "vmalloc: allocation failure: 0 bytes" when reading an
  ETB buffer that is empty.
- It extends current support of CoreSight ETM, that is currently
  very limited.

ETM is a dedicated hardware that provides program tracing, a
cycle-precise and low-overhead solution that software tools such as
'perf record' cannot provide.

Usage of ETM tracing facility is presently limited to start and stop
tracing.  This set of patches enables management of address combinations
and PIDs that trigger tracing, thus allowing to trace specific
functions and processes.  ETM management was done via sysfs entries
(trace_info, trace_running...), this code adds trace_addrrange and
trace_pid to let the user read/write custom values.

Changes in V2:
- Fix a vmalloc/vfree failure when ETB is empty
- Use device attributes rather than raw kobjects
- Make PID_IN_CONTEXTIDR incompatible with PID_NS in Kconfig
- Use pid_t instead of long

Changes in V3:
- Support tracing processes by their PID in PID namespaces
- Reset PID_IN_CONTEXTIDR and PID_NS independent

This series of patches applies to v3.13.

Adrien Vergé (5):
  ARM CoreSight: ETM: Fix a memory allocation failure
  ARM CoreSight: ETM: Use device attributes
  ARM CoreSight: ETM: Rename 'comparator' to 'address comparator'
  ARM CoreSight: ETM: Add address control support
  ARM CoreSight: ETM: Add PID control support

 arch/arm/include/asm/hardware/coresight.h |   9 +-
 arch/arm/kernel/etm.c                     | 257 ++++++++++++++++++++++++------
 2 files changed, 216 insertions(+), 50 deletions(-)

-- 
1.8.5.3

