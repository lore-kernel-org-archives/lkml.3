Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab3LDEiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 23:38:00 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:59380 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab3LDEh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 23:37:59 -0500
MIME-Version: 1.0
Date: Tue, 3 Dec 2013 23:37:58 -0500
Message-ID: <CANsc=4X_C53AHe5p5sRiHDGPA0+P4NgtGWrhOe0h27MZ9LwWbQ@mail.gmail.com>
Subject: ARM Coresight: Enhance ETM tracing control
From: =?UTF-8?Q?Adrien_Verg=C3=A9?= <adrienverge@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Will Deacon <will.deacon@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usage of ETM tracing facility is currently very limited: user can
only start/stop tracing. This set of patches enables management of
address combinations and PIDs that trigger tracing.

ETM management was done via sysfs entries (trace_info,
trace_running...), this code adds trace_addrrange and trace_pid to
let the user read/write custom values.

This series of patches apply to v3.13-rc2.

Signed-off-by: Adrien Vergé <adrienverge@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
---
Adrien Vergé (3):
  ARM Coresight: Rename 'comparator' to 'address comparator' in ETM
  ARM Coresight: Add address control support for ETM tracing
  ARM Coresight: Add PID control support for ETM tracing

 arch/arm/Kconfig.debug                    |   1 +
 arch/arm/include/asm/hardware/coresight.h |   7 +-
 arch/arm/kernel/etm.c                     | 139 ++++++++++++++++++++++++++----
 3 files changed, 129 insertions(+), 18 deletions(-)

-- 
1.8.3.1
