Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3GOKW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:22:27 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33618 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab3GOKWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:22:23 -0400
From: Sudeep.KarkadaNagesha@arm.com
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: cpufreq@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        lorenzo.pieralisi@arm.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, rjw@sisk.pl, viresh.kumar@linaro.org,
        gregkh@linuxfoundation.org, gregory.clement@free-electrons.com,
        kernel@pengutronix.de, shawn.guo@linaro.org, linux@arm.linux.org.uk,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [RFC PATCH 00/11] ARM: DT: update cpu device of_node
Date: Mon, 15 Jul 2013 11:22:01 +0100
Message-Id: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
X-OriginalArrivalTime: 15 Jul 2013 10:22:17.0503 (UTC) FILETIME=[2E9C12F0:01CE8145]
X-MC-Unique: 113071511222005901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6FANx9q007645

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

As more and more information is getting added into the cpu node, the number
of drivers needing to parse the device tree for CPU nodes are increasing.
Most of the time, the information needed from the cpu node is preferred
in the logical CPU order. Hence many drivers first parse and search the
CPU node, match them to logical index if needed and then search for the
required property inside a particular cpu node. Some of them assume the
logical and physical CPU ordering to be same which is incorrect.

This patch series initialises the of_node in all the cpu devices when
registering the CPU device.
1. This avoids different drivers having to parse the cpu nodes to obtain
   different attributes like operating points, latency,...etc.
2. This handles different physical and logical cpu ordering which is not
   the case in current code.
3. Also all the cpu nodes will have their of_node initialised correctly.
   Currently different drivers assign them partially and incorrectly.
4. Removes all the reduntant parsing in various drivers.

Regards,
Sudeep

Sudeep KarkadaNagesha (11):
  driver/core: cpu: initialize of_node in cpu's device struture
  ARM: DT/kernel: define ARM specific arch_of_get_cpu_node
  ARM: topology: remove hwid(MPIDR dependency) from cpu_capacity
  ARM: mvebu: remove device tree parsing for cpu nodes
  drivers/bus: arm-cci: avoid parsing DT for cpu device nodes
  cpufreq: imx6q-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: cpufreq-cpu0: remove device tree parsing for cpu nodes
  cpufreq: highbank-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: spear-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: kirkwood-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: arm_big_little: remove device tree parsing for cpu nodes

 arch/arm/include/asm/prom.h         |  1 +
 arch/arm/kernel/devtree.c           | 29 ++++++++++++++++++
 arch/arm/kernel/topology.c          | 61 ++++++++++++-------------------------
 arch/arm/mach-imx/mach-imx6q.c      |  3 +-
 arch/arm/mach-mvebu/platsmp.c       | 52 +++++++++++++++----------------
 drivers/base/cpu.c                  | 19 ++++++++++++
 drivers/bus/arm-cci.c               | 28 +++++------------
 drivers/cpufreq/arm_big_little_dt.c | 39 +++++++++++-------------
 drivers/cpufreq/cpufreq-cpu0.c      | 23 +++-----------
 drivers/cpufreq/highbank-cpufreq.c  | 18 ++++-------
 drivers/cpufreq/imx6q-cpufreq.c     |  4 +--
 drivers/cpufreq/kirkwood-cpufreq.c  | 14 +++++++--
 drivers/cpufreq/spear-cpufreq.c     | 10 +++++-
 13 files changed, 149 insertions(+), 152 deletions(-)

-- 
1.8.1.2


