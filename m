Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbaJNNtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 09:49:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39801 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaJNNtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 09:49:03 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>, Rob Clark <robdclark@gmail.com>
Subject: [PATCH v2 0/3] VFP fixes
Date: Tue, 14 Oct 2014 06:48:56 -0700
Message-Id: <1413294539-22069-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes allow us to detect VFP correctly on Krait processors.
They also fix short vector emulation for Cortex-A15 and Krait.

Changes since v1:
 * Move to use CPUID and MVFR0 in patch 2
 * Patches 1 and 3 unchanged

Stepan Moskovchenko (1):
  arm: vfp: Bounce undefined instructions in vectored mode

Stephen Boyd (2):
  ARM: vfp: Workaround bad MVFR1 register on some Kraits
  ARM: vfp: Fix VFPv3 hwcap detection on CPUID based cpus

 arch/arm/include/asm/vfp.h |  5 +++
 arch/arm/mm/proc-v7.S      |  5 ++-
 arch/arm/vfp/vfphw.S       |  6 +++
 arch/arm/vfp/vfpmodule.c   | 93 ++++++++++++++++++++++++++--------------------
 4 files changed, 66 insertions(+), 43 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

