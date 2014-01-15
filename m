Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaAORzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:55:54 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44873 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaAORzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:55:38 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/7] Support Krait CPU PMUs
Date: Wed, 15 Jan 2014 09:55:28 -0800
Message-Id: <1389808535-23852-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for the Krait CPU PMUs. I split the main patch
up into two parts: first the basic support that gets us just the architected
events and second the full support patch that tackles the PMRESR interface.

Please note, this patchset relies on the per-cpu irq patch from Vinayak Kale,
7f4a8e7b1943 (genirq: Add an accessor for IRQ_PER_CPU flag, 2013-12-04),
that's sitting in linux-next. Patches are based on commit 21dea6695134 
(ARM: msm_defconfig: Enable restart driver, 2013-12-20) in linux-next.

Changes since v1:
 * Dropped sparse warning patch
 * Reworked percpu irq support patch to hide double pointers in dispatch func
 * Expanded on comments explaining Krait raw event syntax
 * Expanded on DT binding
 * Added qcom,no-pc-write property instead of using cpuid scheme

Stephen Boyd (7):
  ARM: perf_event: Support percpu irqs for the CPU PMU
  ARM: perf_event: Assign pdev pointer earlier for CPU PMUs
  ARM: perf_event: Add basic support for Krait CPU PMUs
  ARM: perf_event: Add hook for event index clearing
  ARM: perf_event: Fully support Krait CPU PMU events
  devicetree: bindings: Document Krait performance monitor units (PMU)
  ARM: dts: msm: Add krait-pmu to platforms with Krait CPUs

 Documentation/devicetree/bindings/arm/pmu.txt |   9 +-
 arch/arm/boot/dts/qcom-msm8960-cdp.dts        |   6 +
 arch/arm/boot/dts/qcom-msm8974.dtsi           |   5 +
 arch/arm/include/asm/pmu.h                    |   1 +
 arch/arm/kernel/perf_event.c                  |  16 +-
 arch/arm/kernel/perf_event_cpu.c              | 103 +++--
 arch/arm/kernel/perf_event_v7.c               | 550 ++++++++++++++++++++++++++
 7 files changed, 656 insertions(+), 34 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

