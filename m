Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbbAFQhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:37:41 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58600 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbbAFQhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:37:39 -0500
From: mathieu.poirier@linaro.org
To: liviu.dudau@arm.com, sudeep.holla@arm.com, lorenzo.pieralisi@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org, patches@linaro.org
Subject: [PATCH 0/9] coresight: Add PM runtime awareness
Date: Tue,  6 Jan 2015 09:37:04 -0700
Message-Id: <1420562233-2015-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

This patchset is using the runtime PM API and the generic power
domain sub-system to prevent coresight power domains from being
switched off while trace scenarios are still being executed.

This is supplemented with the creation of two new generic power
domains for the big and LITTLE clusters on the vexpress-tc2 platform.
By adding coresigth tracers to the power domain they belong to and
using the new generic power domain logic in the spc driver, clusters
are kept powered for as long as coresight operations are ongoing.

Mathieu Poirier (9):
  coresight-etm3x: Adding runtime PM awareness
  coresight-etb: Adding runtime PM awareness
  coresight-funnel: Adding runtime PM awareness
  coresight-tmc: Adding runtime PM awareness
  coresight-tpiu: Adding runtime PM awareness
  coresight-etm3x: Fixing suspend/wake modes
  ARM: vexpress/TC2: Add generic power domain awareness to scp driver
  coresight: Adding DT generic power domain support
  coresight: Documenting reference to generic PD bindings

 .../devicetree/bindings/arm/coresight.txt          |   4 +
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts         |  10 ++
 arch/arm/mach-vexpress/Kconfig                     |   1 +
 arch/arm/mach-vexpress/spc.c                       | 124 ++++++++++++++++++++-
 drivers/coresight/coresight-etb10.c                |  33 ++++--
 drivers/coresight/coresight-etm.h                  |   4 +-
 drivers/coresight/coresight-etm3x.c                |  69 ++++++++----
 drivers/coresight/coresight-funnel.c               |   9 +-
 drivers/coresight/coresight-tmc.c                  |   8 +-
 drivers/coresight/coresight-tpiu.c                 |   7 +-
 10 files changed, 229 insertions(+), 40 deletions(-)

-- 
1.9.1

