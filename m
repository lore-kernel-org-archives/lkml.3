Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab3GWJC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:02:29 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:58828 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab3GWJC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:02:27 -0400
Subject: [PATCH 0/3] cpuidle: (powernv) cpuidle driver. 
To: linuxppc-dev@lists.ozlabs.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Tue, 23 Jul 2013 14:31:22 +0530
Message-ID: <20130723090111.7291.99479.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072308-3864-0000-0000-00000935D486
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch series ports the cpuidle framework for powernv
platform and also implements a cpuidle back-end powernv 
idle driver calling on to power7_nap and snooze idle states.

Moving the idle states over to cpuidle framework can take advantage 
of advanced heuristics, tunables and features provided by cpuidle 
framework. Additional idle states can be exploited using the cpuidle 
framework. The statistics and tracing infrastructure provided by 
the cpuidle framework also helps in enabling power management 
related tools and help tune the system and applications.

This series aims to maintain compatibility and functionality to
existing powernv idle cpu management code.  There are no new functions
or idle states added as part of this series. This can be extended by 
adding more states to this existing framework.

With this patch series the powernv cpuidle functionalities
are on-par with pSeries idle management.

For POWERNV platform to hook into CPUIDLE framework, one
needs to enable CONFIG_POWERNV_IDLE and disable
CONFIG_PSERIES_IDLE 

 Deepthi Dharwar (3):
      cpuidle/powernv: cpuidle backend driver for powernv
      cpuidle/powernv: Enable idle powernv cpu to call into the cpuidle framework.
      cpuidle/powernv: Support smt-snooze-delay parameter in powernv idle.


 arch/powerpc/include/asm/processor.h            |    2 
 arch/powerpc/platforms/powernv/Kconfig          |    9 +
 arch/powerpc/platforms/powernv/Makefile         |    1 
 arch/powerpc/platforms/powernv/powernv.h        |    3 
 arch/powerpc/platforms/powernv/processor_idle.c |  275 +++++++++++++++++++++++
 arch/powerpc/platforms/powernv/setup.c          |   12 +
 6 files changed, 300 insertions(+), 2 deletions(-)
 create mode 100644 arch/powerpc/platforms/powernv/processor_idle.c


-- Deepthi

