Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbaAXQlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 11:41:14 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:47781 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaAXQlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 11:41:13 -0500
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
Subject: [PATCH V2 0/6] ARM CoreSight: Enhance ETM tracing control
Date: Fri, 24 Jan 2014 11:40:50 -0500
Message-Id: <1390581656-16372-1-git-send-email-adrienverge@gmail.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Different ARM users have shown their interest in this patch, so I made
a second version that corrects the first mistakes.

Mainly, it extends current support of CoreSight ETM, that is currently
very limited. ETM provides hardware-assisted program tracing, a
cycle-precise and low-overhead solution that software tools such as
'perf record' cannot provide.

Usage of ETM tracing facility is presently limited to start and stop
tracing. This set of patches enables management of address combinations
and PIDs that trigger tracing, thus allowing to trace specific
functions and processes.

ETM management was done via sysfs entries (trace_info,
trace_running...), this code adds trace_addrrange and trace_pid to
let the user read/write custom values.

Changes in V2:
- Use device attributes rather than raw kobjects
- Make PID_IN_CONTEXTIDR incompatible with PID_NS in Kconfig
- Use int for pid type (not long)
- During trace fetching, call vmalloc() only if really needed

This series of patches applies to v3.13.

Adrien Vergé (6):
  ARM CoreSight: ETM: Use device attributes
  ARM CoreSight: ETM: Rename 'comparator' to 'address comparator'
  ARM CoreSight: ETM: Add address control support
  ARM: Make PID_IN_CONTEXTIDR incompatible with PID_NS
  ARM CoreSight: ETM: Add PID control support
  ARM CoreSight: ETM: Allocate a trace buffer only when necessary

 arch/arm/Kconfig.debug                    |   2 +-
 arch/arm/include/asm/hardware/coresight.h |   9 +-
 arch/arm/kernel/etm.c                     | 208 +++++++++++++++++++++++-------
 arch/arm64/Kconfig.debug                  |   1 +
 4 files changed, 169 insertions(+), 51 deletions(-)

-- 
1.8.5.2

