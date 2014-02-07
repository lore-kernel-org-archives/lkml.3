Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaBGVB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 16:01:29 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56736 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaBGVB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 16:01:26 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 0/7] Support Krait CPU PMUs
Date: Fri,  7 Feb 2014 13:01:18 -0800
Message-Id: <1391806885-24210-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for the Krait CPU PMUs. I split the main patch
up into two parts: first the basic support that gets us just the architected
events and second the full support patch that tackles the PMRESR interface.

Changes since v2:
 * Rebased onto v3.14-rc1
 * Fixed problems found by fuzzer (bitmap logic, per-cpu accesses)

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
 arch/arm/include/asm/pmu.h                    |   2 +
 arch/arm/kernel/perf_event.c                  |  16 +-
 arch/arm/kernel/perf_event_cpu.c              | 103 +++--
 arch/arm/kernel/perf_event_v7.c               | 559 ++++++++++++++++++++++++++
 7 files changed, 666 insertions(+), 34 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

