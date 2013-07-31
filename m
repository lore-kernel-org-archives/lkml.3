Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab3GaDAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 23:00:04 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:59727 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab3GaC77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 22:59:59 -0400
Subject: [PATCH V2 0/6] cpuidle/powerpc: POWERPC cpuidle driver for POWER
 and POWERNV platforms
To: benh@kernel.crashing.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, dongsheng.wang@freescale.com, linux-pm@vger.kernel.org
Date: Wed, 31 Jul 2013 08:28:44 +0530
Message-ID: <20130731025840.19448.24468.stgit@deepthi>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073102-1396-0000-0000-0000035710C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch series consolidates backend cpuidle driver
for pseries and powernv platforms. 

Current existing backend driver for pseries has been moved to
arch/powerpc/sysdev and has been extended to accommodate 
powernv idle power mgmt states. 
As seen in V1 of this patch series, too much code duplication persists
having separate back-end driver for individual platforms.

Moving the idle states over to cpuidle framework can take advantage 
of advanced heuristics, tunables and features provided by cpuidle 
framework. Additional idle states can be exploited using the cpuidle 
framework. The statistics and tracing infrastructure provided by 
the cpuidle framework also helps in enabling power management 
related tools and help tune the system and applications.

This series aims to maintain compatibility and functionality to
existing pseries and powernv idle cpu management code.  
There are no new functions or idle states added as part of this series. 
This can be extended by adding more states to this existing framework.

With this patch series the powernv cpuidle functionalities
are on-par with pSeries idle management. Other POWERPC
platforms can use this to exploit CPUIDLE framework.

This patch mainly focus on an integrated CPUIDLE backend
driver for POWERPC. Minor cpuidle clean-ups will be
taken up going further.

One need to enable POWERPC_IDLE config option to exploit these
backend drivers.

V1 -> http://lkml.org/lkml/2013/7/23/143

 Deepthi Dharwar (6):
      cpuidle/pseries: Fix kernel command line parameter smt-snooze-delay
      cpuidle/pseries: Remove dependency of pseries.h file
      pseries: Move plpar_wrapper.h to powerpc common include/asm location.
      cpuidle/pseries: Move the pseries_idle backend driver to sysdev.
      cpuidle/powerpc: Backend-powerpc idle driver for powernv and pseries.
      cpuidle/powernv: Enable idle powernv cpu to call into the cpuidle framework.


  arch/powerpc/include/asm/plpar_wrappers.h       |  324 ++++++++++++++++++
 arch/powerpc/include/asm/processor.h            |    2 
 arch/powerpc/platforms/powernv/setup.c          |   12 +
 arch/powerpc/platforms/pseries/Kconfig          |    9 
 arch/powerpc/platforms/pseries/Makefile         |    1 
 arch/powerpc/platforms/pseries/cmm.c            |    3 
 arch/powerpc/platforms/pseries/dtl.c            |    3 
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |    3 
 arch/powerpc/platforms/pseries/hvconsole.c      |    2 
 arch/powerpc/platforms/pseries/iommu.c          |    3 
 arch/powerpc/platforms/pseries/kexec.c          |    2 
 arch/powerpc/platforms/pseries/lpar.c           |    2 
 arch/powerpc/platforms/pseries/plpar_wrappers.h |  324 ------------------
 arch/powerpc/platforms/pseries/processor_idle.c |  362 --------------------
 arch/powerpc/platforms/pseries/pseries.h        |    3 
 arch/powerpc/platforms/pseries/setup.c          |    2 
 arch/powerpc/platforms/pseries/smp.c            |    2 
 arch/powerpc/sysdev/Kconfig                     |    9 
 arch/powerpc/sysdev/Makefile                    |    1 
 arch/powerpc/sysdev/processor_idle.c            |  424 +++++++++++++++++++++++
 20 files changed, 780 insertions(+), 713 deletions(-)
 create mode 100644 arch/powerpc/include/asm/plpar_wrappers.h
 delete mode 100644 arch/powerpc/platforms/pseries/plpar_wrappers.h
 delete mode 100644 arch/powerpc/platforms/pseries/processor_idle.c
 create mode 100644 arch/powerpc/sysdev/processor_idle.c


-- Deepthi

