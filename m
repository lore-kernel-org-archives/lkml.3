Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3HVN5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 09:57:33 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46514 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab3HVN5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 09:57:31 -0400
Message-ID: <521618E4.4020007@arm.com>
Date: Thu, 22 Aug 2013 14:57:56 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Sudeep.KarkadaNagesha@arm.com,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Jonas Bonn <jonas@southpole.se>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>
Subject: [GIT PULL v2] DT/core: cpu_ofnode updates for v3.12
X-OriginalArrivalTime: 22 Aug 2013 13:57:26.0636 (UTC) FILETIME=[88BFF2C0:01CE9F3F]
X-MC-Unique: 113082214572906601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Here is the v2 of the pull request for cpu of_node updates for v3.12
It includes ACK for all the new changes since v1(mainly from Ben for
PPC). Currently there's trivial conflict with today's linux-next in 3
files. Let me know if you need me to rebase this on any particular
branch if needed.

Regards,
Sudeep

The following changes since commit b36f4be3de1b123d8601de062e7dbfc904f305fb:

  Linux 3.11-rc6 (2013-08-18 14:36:53 -0700)

are available in the git repository at:

  git://linux-arm.org/linux-skn.git cpu_of_node

for you to fetch changes up to 1037b2752345cc5666e90b711a913ab2ae6c5920:

  cpufreq: pmac32-cpufreq: remove device tree parsing for cpu nodes
(2013-08-21 10:29:56 +0100)

----------------------------------------------------------------
Sudeep KarkadaNagesha (19):
   microblaze: remove undefined of_get_cpu_node declaration
   openrisc: remove undefined of_get_cpu_node declaration
   powerpc: refactor of_get_cpu_node to support other architectures
   of: move of_get_cpu_node implementation to DT core library
   ARM: DT/kernel: define ARM specific arch_match_cpu_phys_id
   driver/core: cpu: initialize of_node in cpu's device struture
   of/device: add helper to get cpu device node from logical cpu index
   ARM: topology: remove hwid/MPIDR dependency from cpu_capacity
   ARM: mvebu: remove device tree parsing for cpu nodes
   drivers/bus: arm-cci: avoid parsing DT for cpu device nodes
   cpufreq: imx6q-cpufreq: remove device tree parsing for cpu nodes
   cpufreq: cpufreq-cpu0: remove device tree parsing for cpu nodes
   cpufreq: highbank-cpufreq: remove device tree parsing for cpu nodes
   cpufreq: spear-cpufreq: remove device tree parsing for cpu nodes
   cpufreq: kirkwood-cpufreq: remove device tree parsing for cpu nodes
   cpufreq: arm_big_little: remove device tree parsing for cpu nodes
   cpufreq: maple-cpufreq: remove device tree parsing for cpu nodes
   cpufreq: pmac64-cpufreq: remove device tree parsing for cpu nodes
   cpufreq: pmac32-cpufreq: remove device tree parsing for cpu nodes

 arch/arm/kernel/devtree.c           |  5 ++
 arch/arm/kernel/topology.c          | 61 +++++-----------
 arch/arm/mach-imx/mach-imx6q.c      |  3 +-
 arch/arm/mach-mvebu/platsmp.c       | 51 ++++++-------
 arch/microblaze/include/asm/prom.h  |  3 -
 arch/openrisc/include/asm/prom.h    |  3 -
 arch/powerpc/include/asm/prom.h     |  3 -
 arch/powerpc/kernel/prom.c          | 43 +-----------
 drivers/base/cpu.c                  |  2 +
 drivers/bus/arm-cci.c               | 28 ++------
 drivers/cpufreq/arm_big_little_dt.c | 40 ++++-------
 drivers/cpufreq/cpufreq-cpu0.c      | 23 +-----
 drivers/cpufreq/highbank-cpufreq.c  | 18 ++---
 drivers/cpufreq/imx6q-cpufreq.c     |  4 +-
 drivers/cpufreq/kirkwood-cpufreq.c  |  8 ++-
 drivers/cpufreq/maple-cpufreq.c     | 23 +-----
 drivers/cpufreq/pmac32-cpufreq.c    |  5 +-
 drivers/cpufreq/pmac64-cpufreq.c    | 47 +++---------
 drivers/cpufreq/spear-cpufreq.c     |  4 +-
 drivers/of/base.c                   | 95 ++++++++++++++++++++++++
 include/linux/cpu.h                 |  1 +
 include/linux/of.h                  |  7 ++
 include/linux/of_device.h           | 15 ++++
 23 files changed, 226 insertions(+), 266 deletions(-)



