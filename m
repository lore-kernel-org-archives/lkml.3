Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbaANLCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:02:14 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:58533 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaANLCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:02:10 -0500
Subject: [PATCH v1] powernv/cpuidle: Back-end cpuidle driver for powernv
 platform for idle state management. 
To: linux-pm@vger.kernel.org, benh@kernel.crashing.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Date: Tue, 14 Jan 2014 16:32:24 +0530
Message-ID: <20140114110157.4091.80684.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011411-8256-0000-0000-00000B005183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch ports the cpuidle framework for powernv
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

For POWERNV platform to hook into CPUIDLE framework, one
needs to enable CONFIG_POWERNV_IDLE. 

This patch series applies on pseries cpuidle backend driver
fixes patchset posted earlier.
pseries/cpuidle: pseries cpuidle backend driver clean-ups.

 Deepthi Dharwar (1):
      powernv/cpuidle: Back-end cpuidle driver for powernv platform.


 arch/powerpc/platforms/powernv/setup.c |   13 ++
 drivers/cpuidle/Kconfig.powerpc        |    9 ++
 drivers/cpuidle/Makefile               |    1 
 drivers/cpuidle/cpuidle-powernv.c      |  169 ++++++++++++++++++++++++++++++++
 4 files changed, 191 insertions(+), 1 deletion(-)
 create mode 100644 drivers/cpuidle/cpuidle-powernv.c


-- Deepthi

