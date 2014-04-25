Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaDYUPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:15:11 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:59787 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751911AbaDYUPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:15:08 -0400
Message-ID: <535AC247.3070907@semaphore.gr>
Date: Fri, 25 Apr 2014 23:15:03 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: Jesper Nilsson <jesper.nilsson@axis.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>, linux-doc@vger.kernel.org,
        cpufreq@vger.kernel.org,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Simon Horman <horms@verge.net.au>, Sekhar Nori <nsekhar@ti.com>,
        Samuel Ortiz <samuel@sortiz.org>
Subject: [PATCH v5 0/8] Introduce new cpufreq helper macros
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch set introduces two freq_table helper macros which
can be used for iteration over cpufreq_frequency_table and
makes the necessary changes to cpufreq core and drivers that
use such an iteration procedure.

The motivation was a usage of common procedure to iterate over
cpufreq_frequency_table across all drivers and cpufreq core.

This was tested on a x86_64 platform.
Most files compiled successfully but unfortunately I was not
able to compile sh_sir.c pasemi_cpufreq.c and ppc_cbe_cpufreq.c 
due to lack of cross compiler.

Changelog 

v4 -> v5
	- Fix warnings in printk format specifier for 32 bit 
	  architectures in freq_table.c, longhaul, pasemi, ppc_cbe
v3 -> v4
	- No changes
v2 -> v3
	- Better formatting in Documentation
	- Fix spell error in comments in cpufreq.h
	- Added 'ARM' prefix in patch 3/8 subject as Sekhar Nori
	  suggested
v1 -> v2
	- Rearrange patches
	- Remove redundant braces
	- Fix a newly introduced bug in exynos5440
	- Use cpufreq_for_each_valid_entry instead of
cpufreq_for_each_entry in cpufreq_frequency_table_get_index()
	- Drop redundant double ! operator in cpu_cooling
	- Change the pos loop cursor variable to freq_pos in longhaul
	- Declare pos variable on a separate line

Stratos Karafotis (8):
  cpufreq: Introduce macros for cpufreq_frequency_table iteration
  cpufreq: Use cpufreq_for_each_* macros for frequency table iteration
  ARM: davinci: da850: Use cpufreq_for_each_entry macro for iteration
  mips: lemote 2f: Use cpufreq_for_each_entry macro for iteration
  mfd: db8500-prcmu: Use cpufreq_for_each_entry macro for iteration
  thermal: cpu_cooling: Use cpufreq_for_each_valid_entry macro for
    iteration
  irda: sh_sir: Use cpufreq_for_each_valid_entry macro for iteration
  sh: clk: Use cpufreq_for_each_valid_entry macro for iteration

 Documentation/cpu-freq/cpu-drivers.txt | 19 ++++++++++++
 arch/arm/mach-davinci/da850.c          |  9 +++---
 arch/mips/loongson/lemote-2f/clock.c   | 16 +++-------
 drivers/cpufreq/acpi-cpufreq.c         |  9 +++---
 drivers/cpufreq/arm_big_little.c       | 16 +++++-----
 drivers/cpufreq/cpufreq.c              | 11 +++++++
 drivers/cpufreq/cpufreq_stats.c        | 24 +++++----------
 drivers/cpufreq/dbx500-cpufreq.c       |  8 ++---
 drivers/cpufreq/elanfreq.c             |  9 +++---
 drivers/cpufreq/exynos-cpufreq.c       | 11 +++----
 drivers/cpufreq/exynos5440-cpufreq.c   | 30 +++++++++---------
 drivers/cpufreq/freq_table.c           | 56 +++++++++++++++-------------------
 drivers/cpufreq/longhaul.c             | 11 +++----
 drivers/cpufreq/pasemi-cpufreq.c       | 10 +++---
 drivers/cpufreq/powernow-k6.c          | 14 ++++-----
 drivers/cpufreq/ppc_cbe_cpufreq.c      |  9 +++---
 drivers/cpufreq/s3c2416-cpufreq.c      | 40 +++++++++++-------------
 drivers/cpufreq/s3c64xx-cpufreq.c      | 15 +++------
 drivers/mfd/db8500-prcmu.c             | 19 +++++-------
 drivers/net/irda/sh_sir.c              | 14 +++------
 drivers/sh/clk/core.c                  | 20 +++---------
 drivers/thermal/cpu_cooling.c          | 33 ++++++++------------
 include/linux/cpufreq.h                | 21 +++++++++++++
 23 files changed, 208 insertions(+), 216 deletions(-)

-- 
1.9.0
