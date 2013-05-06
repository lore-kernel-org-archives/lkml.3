Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab3EFOud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:50:33 -0400
Received: from smtp.citrix.com ([66.165.176.89]:1526 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab3EFOuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:50:32 -0400
X-IronPort-AV: E=Sophos;i="4.87,622,1363132800"; 
   d="scan'208";a="23502385"
Date: Mon, 6 May 2013 15:50:22 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH RFC v2 0/4] xen/arm: CONFIG_PARAVIRT and stolen ticks
 accounting
Message-ID: <alpine.DEB.2.02.1305061532310.4756@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series introduces stolen ticks accounting for Xen on ARM.
Stolen ticks are clocksource ticks that have been "stolen" from the cpu,
typically because Linux is running in a virtual machine and the vcpu has
been descheduled.
To account for these ticks we introduce CONFIG_PARAVIRT and pv_time_ops
so that we can make use of:

kernel/sched/cputime.c:steal_account_process_tick



Stefano Stabellini (4):
      xen: move xen_setup_runstate_info and get_runstate_snapshot to drivers/xen/time.c
      arm: introduce CONFIG_PARAVIRT and pv_time_ops
      kernel: missing include in cputime.c
      xen/arm: account for stolen ticks

 arch/arm/Kconfig                |    9 ++++
 arch/arm/include/asm/paravirt.h |   19 ++++++++
 arch/arm/kernel/Makefile        |    1 +
 arch/arm/kernel/paravirt.c      |   32 ++++++++++++++
 arch/arm/xen/enlighten.c        |   23 ++++++++++
 arch/ia64/xen/time.c            |   48 +++------------------
 arch/x86/xen/time.c             |   76 +--------------------------------
 drivers/xen/Makefile            |    2 +-
 drivers/xen/time.c              |   91 +++++++++++++++++++++++++++++++++++++++
 include/xen/xen-ops.h           |    5 ++
 kernel/sched/cputime.c          |    1 +
 11 files changed, 189 insertions(+), 118 deletions(-)
 create mode 100644 arch/arm/include/asm/paravirt.h
 create mode 100644 arch/arm/kernel/paravirt.c
 create mode 100644 drivers/xen/time.c



Cheers,

Stefano
