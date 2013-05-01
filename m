Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab3EAT1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 15:27:17 -0400
Received: from smtp.citrix.com ([66.165.176.89]:21536 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab3EAT1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 15:27:12 -0400
X-IronPort-AV: E=Sophos;i="4.87,590,1363132800"; 
   d="scan'208";a="22708177"
Date: Wed, 1 May 2013 20:27:07 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH 0/3] xen/arm: account for stolen ticks
Message-ID: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this small patch series introduces stolen ticks accounting for Xen on
ARM. Stolen ticks are clocksource ticks that have been "stolen" from the
cpu, typically because Linux is running in a virtual machine and the
vcpu has been descheduled.


Stefano Stabellini (3):
      arm_arch_timer: introduce arch_timer_stolen_ticks
      xen: move do_stolen_accounting to drivers/xen/time.c
      xen/arm: account for stolen ticks

 arch/arm/include/asm/arch_timer.h    |    5 +
 arch/arm/xen/enlighten.c             |    4 +
 arch/x86/xen/time.c                  |  127 +------------------------------
 drivers/clocksource/arm_arch_timer.c |    6 ++
 drivers/xen/Makefile                 |    2 +-
 drivers/xen/time.c                   |  142 ++++++++++++++++++++++++++++++++++
 include/xen/xen-ops.h                |    4 +
 7 files changed, 163 insertions(+), 127 deletions(-)
 create mode 100644 drivers/xen/time.c


 git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git lost_ticks_1


Cheers,

Stefano
