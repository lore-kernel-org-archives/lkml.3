Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab3FEQBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:01:34 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:34036 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755992Ab3FEQBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:01:33 -0400
Message-ID: <51AF60C1.9050409@semaphore.gr>
Date: Wed, 05 Jun 2013 19:01:05 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] cpufreq: ondemand: Change the calculation of target
 frequency
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:
	- Reorder patches 2/3 and 3/3
	- Fix typos in patch changelog

Changes since v1:
	- Use policy->cpuinfo.max_freq in the calculation formula
		of target frequency instead of policy->max
	- Split the patch into 3 parts

Stratos Karafotis (3):
  cpufreq: ondemand: Change the calculation of target frequency
  cpufreq: Remove unused APERF/MPERF support
  cpufreq: Remove unused function __cpufreq_driver_getavg

 arch/x86/include/asm/processor.h   | 29 ----------------------
 drivers/cpufreq/Makefile           |  2 +-
 drivers/cpufreq/acpi-cpufreq.c     |  5 ----
 drivers/cpufreq/cpufreq.c          | 12 ---------
 drivers/cpufreq/cpufreq_governor.c | 10 +-------
 drivers/cpufreq/cpufreq_governor.h |  1 -
 drivers/cpufreq/cpufreq_ondemand.c | 39 ++++++-----------------------
 drivers/cpufreq/mperf.c            | 51 --------------------------------------
 drivers/cpufreq/mperf.h            |  9 -------
 include/linux/cpufreq.h            |  6 -----
 10 files changed, 9 insertions(+), 155 deletions(-)
 delete mode 100644 drivers/cpufreq/mperf.c
 delete mode 100644 drivers/cpufreq/mperf.h

-- 
1.8.1.4

