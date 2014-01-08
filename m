Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbaAHSti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:49:38 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:27998 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaAHStf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:49:35 -0500
X-IronPort-AV: E=Sophos;i="4.95,625,1384300800"; 
   d="scan'208";a="88846571"
Date: Wed, 8 Jan 2014 18:48:42 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v8 0/6] xen/arm/arm64: CONFIG_PARAVIRT and stolen ticks
 accounting
Message-ID: <alpine.DEB.2.02.1401081845040.21510@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series introduces stolen ticks accounting for Xen on ARM and
ARM64.
Stolen ticks are clocksource ticks that have been "stolen" from the cpu,
typically because Linux is running in a virtual machine and the vcpu has
been descheduled.
To account for these ticks we introduce CONFIG_PARAVIRT and pv_time_ops
so that we can make use of:

kernel/sched/cputime.c:steal_account_process_tick


Changes in v8:
- rebased on 3.13-rc6.



Stefano Stabellini (6):
      xen: move xen_setup_runstate_info and get_runstate_snapshot to drivers/xen/time.c
      kernel: missing include in cputime.c
      arm: introduce CONFIG_PARAVIRT, PARAVIRT_TIME_ACCOUNTING and pv_time_ops
      arm64: introduce CONFIG_PARAVIRT, PARAVIRT_TIME_ACCOUNTING and pv_time_ops
      core: remove ifdef CONFIG_PARAVIRT
      xen/arm: account for stolen ticks

 arch/arm/Kconfig           |   20 ++++++++++
 arch/arm/kernel/Makefile   |    1 +
 arch/arm/xen/enlighten.c   |   21 ++++++++++
 arch/arm64/Kconfig         |   20 ++++++++++
 arch/arm64/kernel/Makefile |    1 +
 arch/ia64/xen/time.c       |   48 +++--------------------
 arch/x86/xen/time.c        |   76 +-----------------------------------
 drivers/xen/Makefile       |    2 +-
 drivers/xen/time.c         |   91 ++++++++++++++++++++++++++++++++++++++++++++
 include/xen/xen-ops.h      |    5 +++
 kernel/sched/core.c        |    2 -
 kernel/sched/cputime.c     |    1 +
 12 files changed, 168 insertions(+), 120 deletions(-)
 create mode 100644 drivers/xen/time.c

git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git lost_ticks_8


Cheers,

Stefano
