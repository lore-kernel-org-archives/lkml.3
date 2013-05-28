Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964943Ab3E1Rxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:53:43 -0400
Received: from smtp.citrix.com ([66.165.176.89]:9164 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964922Ab3E1Rxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:53:42 -0400
X-IronPort-AV: E=Sophos;i="4.87,759,1363132800"; 
   d="scan'208";a="27798274"
Date: Tue, 28 May 2013 18:53:24 +0100
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
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: [PATCH v4 0/4] xen/arm: CONFIG_PARAVIRT and stolen ticks
 accounting
Message-ID: <alpine.DEB.2.02.1305281835080.4799@kaball.uk.xensource.com>
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
      kernel: missing include in cputime.c
      arm: introduce CONFIG_PARAVIRT, PARAVIRT_TIME_ACCOUNTING and pv_time_ops
      xen/arm: account for stolen ticks

 arch/arm/Kconfig                |   20 +++++++++
 arch/arm/include/asm/paravirt.h |   19 ++++++++
 arch/arm/kernel/Makefile        |    1 +
 arch/arm/kernel/paravirt.c      |   25 +++++++++++
 arch/arm/xen/enlighten.c        |   21 +++++++++
 arch/ia64/xen/time.c            |   48 +++------------------
 arch/x86/xen/time.c             |   76 +--------------------------------
 drivers/xen/Makefile            |    2 +-
 drivers/xen/time.c              |   91 +++++++++++++++++++++++++++++++++++++++
 include/xen/xen-ops.h           |    5 ++
 kernel/sched/cputime.c          |    1 +
 11 files changed, 191 insertions(+), 118 deletions(-)
 create mode 100644 arch/arm/include/asm/paravirt.h
 create mode 100644 arch/arm/kernel/paravirt.c
 create mode 100644 drivers/xen/time.c


git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git lost_ticks_4

Cheers,

Stefano
